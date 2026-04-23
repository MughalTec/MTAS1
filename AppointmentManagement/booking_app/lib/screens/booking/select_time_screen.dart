import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';
import '../../services/booking_service.dart';
import '../../widgets/custom_button.dart';

class SelectTimeScreen extends StatefulWidget {
  final ProviderModel provider;
  final ServiceModel service;

  const SelectTimeScreen({
    super.key,
    required this.provider,
    required this.service,
  });

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _selectedSlot;
  List<DateTime> _availableSlots = [];
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadSlotsForDay(DateTime.now());
  }

  Future<void> _loadSlotsForDay(DateTime day) async {
    setState(() {
      _isLoadingSlots = true;
      _selectedSlot = null;
    });

    try {
      final bookingService = BookingService();
      final slots = await bookingService.getAvailableSlots(
        providerId: widget.provider.id,
        service: widget.service,
        date: day,
      );
      setState(() {
        _availableSlots = slots;
        _isLoadingSlots = false;
      });
    } catch (e) {
      setState(() => _isLoadingSlots = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.service.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Service Summary Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.schedule, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(widget.service.durationFormatted,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 16),
                Icon(Icons.attach_money, size: 16, color: AppTheme.textSecondary),
                Text(widget.service.priceFormatted,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Container(
                    color: Colors.white,
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now()
                          .add(const Duration(days: 60)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _loadSlotsForDay(selectedDay);
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle:
                            TextStyle(color: AppTheme.primary),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Time Slots
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDay != null
                              ? 'Available times on ${DateFormat('EEEE, MMMM d').format(_selectedDay!)}'
                              : 'Select a date',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),

                        if (_isLoadingSlots)
                          const Center(child: CircularProgressIndicator())
                        else if (_availableSlots.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'No available slots on this day.\nPlease select another date.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _availableSlots.length,
                            itemBuilder: (context, index) {
                              final slot = _availableSlots[index];
                              final isSelected =
                                  _selectedSlot != null &&
                                      slot == _selectedSlot;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedSlot = slot),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primary
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    DateFormat('HH:mm').format(slot),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: CustomButton(
              label: 'Continue',
              isLoading: false,
              onPressed: _selectedSlot == null
                  ? null
                  : () {
                      context.push(
                        '/book/${widget.provider.bookingPageSlug}/details',
                        extra: {
                          'provider': widget.provider,
                          'service': widget.service,
                          'selectedSlot': _selectedSlot,
                        },
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
