import 'package:flutter/material.dart';
import 'dart:async';
import '../models/booking_model.dart';
import '../services/firestore_service.dart';

class BookingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  StreamSubscription? _bookingsSubscription;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  List<BookingModel> get upcomingBookings => _bookings
      .where((b) => b.isUpcoming)
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));

  List<BookingModel> get todayBookings {
    final today = DateTime.now();
    return _bookings
        .where((b) =>
            b.startTime.day == today.day &&
            b.startTime.month == today.month &&
            b.startTime.year == today.year &&
            b.status != BookingStatus.cancelled)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<void> loadBookings(String providerId) async {
    _isLoading = true;
    notifyListeners();

    _bookingsSubscription?.cancel();
    _bookingsSubscription = _firestoreService
        .watchProviderBookings(providerId)
        .listen((bookings) {
      _bookings = bookings;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await _firestoreService.updateBookingStatus(
      bookingId,
      BookingStatus.cancelled,
      cancellationReason: reason,
    );
  }

  Future<void> completeBooking(String bookingId) async {
    await _firestoreService.updateBookingStatus(
      bookingId,
      BookingStatus.completed,
    );
  }

  Future<void> markNoShow(String bookingId) async {
    await _firestoreService.updateBookingStatus(
      bookingId,
      BookingStatus.noShow,
    );
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
  }
}
