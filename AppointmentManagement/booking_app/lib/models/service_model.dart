enum ServiceLocationType {
  online,
  atLocation,
  atClientAddress,
  both
}


class ServiceModel {

  final String id;
  final String providerId;

  final String name;
  final String description;

  final int durationMinutes;

  final double price;

  final String currency;

  final ServiceLocationType locationType;

  final bool isActive;

  final String? imageUrl;

  final int sortOrder;

  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.currency,
    required this.locationType,
    required this.isActive,
    this.imageUrl,
    required this.sortOrder,
    required this.createdAt,
  });

  String get durationFormatted {

    if (durationMinutes >= 60) {

      final h = durationMinutes ~/ 60;
      final m = durationMinutes % 60;

      if (m == 0) {
        return '${h}h';
      }

      return '${h}h ${m}m';
    }

    return '${durationMinutes}m';
  }

  String get priceFormatted {

    return '\$${price.toStringAsFixed(2)}';
  }

  String get locationTypeLabel {

    switch (locationType) {

      case ServiceLocationType.online:
        return 'Online';

      case ServiceLocationType.atLocation:
        return 'At Location';

      case ServiceLocationType.atClientAddress:
        return 'At Client Address';

      case ServiceLocationType.both:
        return 'Both';
    }
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: (json['id'] ?? json['ID']).toString(),   // 🔥 FIX
      providerId: (json['provider_id'] ?? '').toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      durationMinutes: int.tryParse(json['duration_minutes']?.toString() ?? '0') ?? 0,
      currency: json['currency'] ?? 'USD',
      locationType: ServiceLocationType.atLocation,
      isActive: json['is_active'] ?? true,
      imageUrl: json['image_url'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
