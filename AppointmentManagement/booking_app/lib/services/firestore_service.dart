import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/provider_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/availability_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- Providers ----

  Future<ProviderModel?> getProviderBySlug(String slug) async {
    final query = await _db
        .collection('providers')
        .where('bookingPageSlug', isEqualTo: slug)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return ProviderModel.fromFirestore(query.docs.first);
  }

  Future<void> updateProvider(String id, Map<String, dynamic> data) async {
    await _db.collection('providers').doc(id).update(data);
  }

  Stream<ProviderModel?> watchProvider(String id) {
    return _db.collection('providers').doc(id).snapshots().map(
          (doc) => doc.exists ? ProviderModel.fromFirestore(doc) : null,
        );
  }

  // ---- Services ----

  Future<List<ServiceModel>> getActiveServices(String providerId) async {
    final query = await _db
        .collection('services')
        .where('providerId', isEqualTo: providerId)
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();

    return query.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList();
  }

  Stream<List<ServiceModel>> watchServices(String providerId) {
    return _db
        .collection('services')
        .where('providerId', isEqualTo: providerId)
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList());
  }

  Future<void> addService(ServiceModel service) async {
    await _db.collection('services').add(service.toFirestore());
  }

  Future<void> updateService(String id, Map<String, dynamic> data) async {
    await _db.collection('services').doc(id).update(data);
  }

  Future<void> deleteService(String id) async {
    await _db.collection('services').doc(id).delete();
  }

  // ---- Bookings ----

  Stream<List<BookingModel>> watchProviderBookings(String providerId) {
    return _db
        .collection('bookings')
        .where('providerId', isEqualTo: providerId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => BookingModel.fromFirestore(doc)).toList());
  }

  Future<List<BookingModel>> getBookingsForDate(
      String providerId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = await _db
        .collection('bookings')
        .where('providerId', isEqualTo: providerId)
        .where('startTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThan: Timestamp.fromDate(endOfDay))
        .where('status', whereIn: ['confirmed', 'pending'])
        .get();

    return query.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
  }

  Future<DocumentReference> createBooking(BookingModel booking) async {
    return await _db.collection('bookings').add(booking.toFirestore());
  }

  Future<void> updateBookingStatus(
      String id, BookingStatus status, {String? cancellationReason}) async {
    final data = <String, dynamic>{'status': status.name};
    if (cancellationReason != null) {
      data['cancellationReason'] = cancellationReason;
    }
    await _db.collection('bookings').doc(id).update(data);
  }

  // ---- Availability ----

  Future<AvailabilityModel?> getAvailability(String providerId) async {
    final doc = await _db.collection('availability').doc(providerId).get();
    if (!doc.exists) return null;
    return AvailabilityModel.fromFirestore(doc.data()!);
  }

  Future<void> updateAvailability(AvailabilityModel availability) async {
    await _db
        .collection('availability')
        .doc(availability.providerId)
        .set(availability.toFirestore(), SetOptions(merge: true));
  }

  // ---- Admin ----

  Future<List<ProviderModel>> getAllProviders({int limit = 50}) async {
    final query = await _db
        .collection('providers')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return query.docs
        .map((doc) => ProviderModel.fromFirestore(doc))
        .toList();
  }

  Stream<int> watchTotalProviders() {
    return _db
        .collection('providers')
        .snapshots()
        .map((snap) => snap.size);
  }
}
