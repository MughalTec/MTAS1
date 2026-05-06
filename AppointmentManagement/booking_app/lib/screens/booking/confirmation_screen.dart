import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../models/provider_model.dart';

class ConfirmationScreen extends StatelessWidget {
  final BookingModel booking;
  final ProviderModel provider;

  const ConfirmationScreen({
    super.key,
    required this.booking,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: AppTheme.secondary,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'A confirmation has been sent to ${booking.clientEmail}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Booking Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    _DetailRow(
                      label: 'Booking ID',
                      value: '#${booking.id.substring(0, 8).toUpperCase()}',
                    ),
                    _DetailRow(
                      label: 'Business',
                      value: provider.businessName,
                    ),
                    _DetailRow(
                      label: 'Service',
                      value: booking.serviceName,
                    ),
                    _DetailRow(
                      label: 'Date',
                      value: DateFormat('EEEE, MMMM d, yyyy')
                          .format(booking.startTime),
                    ),
                    _DetailRow(
                      label: 'Time',
                      value:
                          '${DateFormat('HH:mm').format(booking.startTime)} - ${DateFormat('HH:mm').format(booking.endTime)}',
                    ),
                    _DetailRow(
                      label: 'Duration',
                      value: '${booking.serviceDurationMinutes} minutes',
                    ),
                    if (booking.servicePrice > 0)
                      _DetailRow(
                        label: 'Price',
                        value:
                            '${AppConfig.currencySymbol}${booking.servicePrice.toStringAsFixed(2)}',
                      ),
                    _DetailRow(
                      label: 'Name',
                      value: booking.clientName,
                    ),
                    _DetailRow(
                      label: 'Email',
                      value: booking.clientEmail,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cancel Note
              Text(
                'Need to cancel or reschedule? Contact ${provider.businessName} directly.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  ),
                  child: const Text('Done'),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Powered by ${AppConfig.appName}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
