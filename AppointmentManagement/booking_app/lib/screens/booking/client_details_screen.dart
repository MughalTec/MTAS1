import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';
import '../../services/booking_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ProviderModel provider;
  final ServiceModel service;
  final DateTime selectedSlot;

  const ClientDetailsScreen({
    super.key,
    required this.provider,
    required this.service,
    required this.selectedSlot,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bookingService = BookingService();
      final booking = await bookingService.createBooking(
        provider: widget.provider,
        service: widget.service,
        startTime: widget.selectedSlot,
        clientName: _nameController.text.trim(),
        clientEmail: _emailController.text.trim(),
        clientPhone: _phoneController.text.trim(),
        clientNotes: _notesController.text.trim(),
      );

      if (mounted) {
        context.pushReplacement(
          '/book/${widget.provider.bookingPageSlug}/confirmation',
          extra: {'booking': booking, 'provider': widget.provider},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final endTime = widget.selectedSlot
        .add(Duration(minutes: widget.service.durationMinutes));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Your details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppTheme.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Summary',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const Divider(height: 20),
                        _SummaryRow(
                          icon: Icons.business,
                          label: 'Business',
                          value: widget.provider.businessName,
                        ),
                        _SummaryRow(
                          icon: Icons.spa,
                          label: 'Service',
                          value: widget.service.name,
                        ),
                        _SummaryRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: DateFormat('EEEE, MMMM d, yyyy')
                              .format(widget.selectedSlot),
                        ),
                        _SummaryRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value:
                              '${DateFormat('HH:mm').format(widget.selectedSlot)} - ${DateFormat('HH:mm').format(endTime)}',
                        ),
                        _SummaryRow(
                          icon: Icons.attach_money,
                          label: 'Price',
                          value: widget.service.priceFormatted,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Your Information',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          validator: Validators.required,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.email_outlined),
                            helperText: 'Confirmation will be sent here',
                          ),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: Validators.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Notes (optional)',
                            prefixIcon: Icon(Icons.notes_outlined),
                            hintText: 'Any information you want to share...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: CustomButton(
              label: 'Confirm Booking',
              isLoading: _isLoading,
              onPressed: _confirmBooking,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
