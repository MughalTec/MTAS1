import 'package:uuid/uuid.dart';
import '../models/booking_model.dart';
import '../models/provider_model.dart';
import '../models/service_model.dart';
import 'firestore_service.dart';

class BookingService {
  final FirestoreService _firestoreService = FirestoreService();
  final _uuid = const Uuid();

  /// Returns a list of available DateTime slots for a given provider, service, and date
  Future<List<DateTime>> getAvailableSlots({
    required String providerId,
    required ServiceModel service,
    required DateTime date,
  }) async {
    // Get provider availability settings
    final availability = await _firestoreService.getAvailability(providerId);
    if (availability == null) return [];

    // Get day name
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    final dayName = dayNames[date.weekday - 1];

    // Check if provider works this day
    if (!availability.isDayAvailable(dayName)) return [];

    // Check if date is blocked
    final isBlocked = availability.blockedDates.any(
      (d) => d.day == date.day && d.month == date.month && d.year == date.year,
    );
    if (isBlocked) return [];

    // Get working hours for this day
    final timeSlots = availability.weeklySchedule[dayName] ?? [];
    if (timeSlots.isEmpty) return [];

    // Get existing bookings for this day
    final existingBookings = await _firestoreService.getBookingsForDate(
      providerId,
      date,
    );

    // Generate available slots
    final slots = <DateTime>[];
    final slotDuration = service.durationMinutes + service.bufferTimeMinutes;
    final now = DateTime.now();

    for (final timeSlot in timeSlots) {
      final startParts = timeSlot.startTime.split(':');
      final endParts = timeSlot.endTime.split(':');

      var current = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final workEnd = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      while (current
              .add(Duration(minutes: service.durationMinutes))
              .isBefore(workEnd) ||
          current.add(Duration(minutes: service.durationMinutes)) == workEnd) {
        // Skip past time slots
        if (current.isBefore(now.add(const Duration(minutes: 60)))) {
          current = current.add(Duration(minutes: slotDuration));
          continue;
        }

        // Check conflicts with existing bookings
        final slotEnd = current.add(Duration(minutes: service.durationMinutes));
        final hasConflict = existingBookings.any((booking) {
          return current.isBefore(booking.endTime) &&
              slotEnd.isAfter(booking.startTime);
        });

        if (!hasConflict) {
          slots.add(current);
        }

        current = current.add(Duration(minutes: slotDuration));
      }
    }

    return slots;
  }

  /// Creates a booking and sends confirmation emails
  Future<BookingModel> createBooking({
    required ProviderModel provider,
    required ServiceModel service,
    required DateTime startTime,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    String? clientNotes,
  }) async {
    final endTime = startTime.add(Duration(minutes: service.durationMinutes));

    final booking = BookingModel(
      id: _uuid.v4(),
      providerId: provider.id,
      serviceId: service.id,
      serviceName: service.name,
      serviceDurationMinutes: service.durationMinutes,
      servicePrice: service.price,
      clientName: clientName,
      clientEmail: clientEmail,
      clientPhone: clientPhone,
      clientNotes: clientNotes,
      startTime: startTime,
      endTime: endTime,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    final docRef = await _firestoreService.createBooking(booking);

    // Return booking with Firestore ID
    return BookingModel(
      id: docRef.id,
      providerId: booking.providerId,
      serviceId: booking.serviceId,
      serviceName: booking.serviceName,
      serviceDurationMinutes: booking.serviceDurationMinutes,
      servicePrice: booking.servicePrice,
      clientName: booking.clientName,
      clientEmail: booking.clientEmail,
      clientPhone: booking.clientPhone,
      clientNotes: booking.clientNotes,
      startTime: booking.startTime,
      endTime: booking.endTime,
      status: booking.status,
      createdAt: booking.createdAt,
    );
    // Note: Email confirmation is handled by a Firebase Cloud Function
    // that triggers on new booking creation in Firestore
  }
}
