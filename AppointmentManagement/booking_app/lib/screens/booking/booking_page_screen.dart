import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';
import '../../services/firestore_service.dart';

class BookingPageScreen extends StatefulWidget {
  final String slug; // provider's unique booking page slug

  const BookingPageScreen({super.key, required this.slug});

  @override
  State<BookingPageScreen> createState() => _BookingPageScreenState();
}

class _BookingPageScreenState extends State<BookingPageScreen> {
  bool _isLoading = true;
  ProviderModel? _provider;
  List<ServiceModel> _services = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProviderPage();
  }

  Future<void> _loadProviderPage() async {
    try {
      final firestoreService = FirestoreService();
      final provider = await firestoreService.getProviderBySlug(widget.slug);
      if (provider == null) {
        setState(() {
          _error = 'Booking page not found';
          _isLoading = false;
        });
        return;
      }
      final services = await firestoreService.getActiveServices(provider.id);
      setState(() {
        _provider = provider;
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load booking page';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _provider == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppTheme.error),
              const SizedBox(height: 16),
              Text(_error ?? 'Not found'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Provider Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Provider Logo or Initial
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _provider!.businessLogoUrl != null
                          ? NetworkImage(_provider!.businessLogoUrl!)
                          : null,
                      child: _provider!.businessLogoUrl == null
                          ? Text(
                              _provider!.businessName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _provider!.businessName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _provider!.businessCategory,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Business Description
                if (_provider!.businessDescription.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _provider!.businessDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Select a Service
                Text(
                  'Select a Service',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),

                if (_services.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('No services available at this time.'),
                    ),
                  )
                else
                  ..._services.map((service) => _ServiceTile(
                        service: service,
                        onTap: () {
                          context.push(
                            '/book/${widget.slug}/select-time',
                            extra: {
                              'provider': _provider,
                              'service': service,
                            },
                          );
                        },
                      )),

                const SizedBox(height: 40),

                // Powered By Footer
                Center(
                  child: Text(
                    'Powered by ${AppConfig.appName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceTile({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (service.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        service.durationFormatted,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        service.locationTypeLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  service.priceFormatted,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppTheme.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
