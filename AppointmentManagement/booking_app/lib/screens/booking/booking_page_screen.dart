/*import 'package:booking_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';

class BookingPageScreen extends StatefulWidget {
  final String slug;

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
    _load();
  }

  Future<void> _load() async {
    final api = ApiService();

    final provider = await ApiService.getProviderBySlug(widget.slug);

    if (provider == null) {
      setState(() {
        _error = "Provider not found";
        _isLoading = false;
      });
      return;
    }

    final services = await api.getServices(provider.id);

    setState(() {
      _provider = provider;
      _services = services;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (_provider == null) {
      return const Scaffold(
        body: Center(child: Text("Provider not found")),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [

          // ================= HEADER =================
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const SizedBox(height: 40),

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _provider!.businessLogoUrl != null
                          ? NetworkImage(_provider!.businessLogoUrl!)
                          : null,
                      child: _provider!.businessLogoUrl == null
                          ? Text(
                        _provider!.businessName.isNotEmpty
                            ? _provider!.businessName[0].toUpperCase()
                            : "P",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _provider!.businessName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      _provider!.businessCategory,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= BODY =================
          SliverList(
            delegate: SliverChildListDelegate([

              const SizedBox(height: 16),

              if (_provider!.businessDescription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_provider!.businessDescription),
                ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Select a Service",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // SERVICES
              if (_services.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No services available")),
                )
              else
                ..._services.map((service) {
                  return _ServiceTile(
                    service: service,
                    onTap: () {
                      context.push(
                        '/book/${widget.slug}/select-time',
                        extra: {
                          "provider": _provider,
                          "service": service,
                        },
                      );
                    },
                  );
                }),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Powered by Booking App",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}

// ================= SERVICE TILE =================
class _ServiceTile extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            )
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    service.durationFormatted,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            Text(
              service.priceFormatted,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/























/*
import 'package:booking_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../models/provider_model.dart';
import '../../models/service_model.dart';

class BookingPageScreen extends StatefulWidget {
  final String slug;

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
      final api = ApiService();

      // 1️⃣ GET PROVIDER
      final provider = await ApiService.getProviderBySlug(widget.slug);

      if (provider == null) {
        setState(() {
          _error = "Provider not found";
          _isLoading = false;
        });
        return;
      }

      // 2️⃣ GET SERVICES
      final services = await api.getServices(provider.id);

      setState(() {
        _provider = provider;
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Server error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (_provider == null) {
      return const Scaffold(
        body: Center(child: Text("Provider not found")),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [

          // ================= HEADER =================
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const SizedBox(height: 40),

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _provider!.businessLogoUrl != null
                          ? NetworkImage(_provider!.businessLogoUrl!)
                          : null,
                      child: _provider!.businessLogoUrl == null
                          ? Text(
                        _provider!.businessName.isNotEmpty
                            ? _provider!.businessName[0].toUpperCase()
                            : "P",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _provider!.businessName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      _provider!.businessCategory,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= BODY =================
          SliverList(
            delegate: SliverChildListDelegate([

              const SizedBox(height: 16),

              if (_provider!.businessDescription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_provider!.businessDescription),
                ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Select a Service",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // SERVICES
              if (_services.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No services available")),
                )
              else
                ..._services.map((service) {
                  return _ServiceTile(
                    service: service,
                    onTap: () {
                      context.push(
                        '/book/${widget.slug}/select-time',
                        extra: {
                          "provider": _provider,
                          "service": service,
                        },
                      );
                    },
                  );
                }),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Powered by Booking App",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}

// ================= SERVICE TILE =================
class _ServiceTile extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            )
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    service.durationFormatted,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            Text(
              service.priceFormatted,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




*/
