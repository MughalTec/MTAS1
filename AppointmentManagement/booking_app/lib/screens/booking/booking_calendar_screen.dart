import 'package:booking_app/models/provider_model.dart';
import 'package:booking_app/screens/booking/create_booking_screen.dart';
import 'package:booking_app/services/api_service.dart';

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingCalendarScreen extends StatefulWidget {

  final ProviderModel provider;

  const BookingCalendarScreen({
    super.key,
    required this.provider,
  });

  @override
  State<BookingCalendarScreen> createState() =>
      _BookingCalendarScreenState();
}

class _BookingCalendarScreenState
    extends State<BookingCalendarScreen> {

  final ApiService api = ApiService();

  List<Appointment> meetings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  // =====================================
  // LOAD BOOKINGS
  // =====================================

  Future<void> loadBookings() async {

    try {

      final bookings =
      await api.getBookings();

      meetings = bookings.map((b) {

        return Appointment(

          startTime: b.startTime,

          endTime: b.endTime,

          subject:
          "${b.clientName}\n${b.serviceName}",

          notes: b.status,
        );

      }).toList();

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================
  // UI
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Bookings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateBookingScreen(
                provider: widget.provider,
              ),
            ),
          );

          if (result == true) {
            loadBookings();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("New Booking"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: SfCalendar(
            view: CalendarView.month,
            allowedViews: const [
              CalendarView.month,
              CalendarView.week,
              CalendarView.day,
            ],
            dataSource: MeetingDataSource(meetings),

            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode:
              MonthAppointmentDisplayMode.appointment,
            ),
          ),
        ),
      ),
    );
  }
  /*Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Bookings"),
      ),

      // =====================================
      // ADD BOOKING BUTTON
      // =====================================

      floatingActionButton:
      FloatingActionButton(

        onPressed: () async {

          final result =
          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  CreateBookingScreen(
                    provider:
                    widget.provider,
                  ),
            ),
          );

          // REFRESH CALENDAR
          if (result == true) {
            loadBookings();
          }
        },

        child: const Icon(Icons.add),
      ),

      // =====================================
      // BODY
      // =====================================

      body:

      isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SfCalendar(

        view: CalendarView.month,

        allowedViews: const [

          CalendarView.month,

          CalendarView.week,

          CalendarView.day,
        ],

        dataSource:
        MeetingDataSource(meetings),

        monthViewSettings:
        const MonthViewSettings(

          appointmentDisplayMode:
          MonthAppointmentDisplayMode
              .appointment,
        ),
      ),
    );
  }*/


}

// =====================================
// CALENDAR DATA SOURCE
// =====================================

class MeetingDataSource
    extends CalendarDataSource {

  MeetingDataSource(
      List<Appointment> source
      ) {

    appointments = source;
  }
}