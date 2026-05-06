import 'package:cloud_firestore/cloud_firestore.dart';

enum ServiceLocationType { online, atLocation, atClientAddress, both }

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
  final int bufferTimeMinutes; // time between appointments
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
    this.currency = 'USD',
    required this.locationType,
    this.isActive = true,
    this.bufferTimeMinutes = 0,
    this.imageUrl,
    this.sortOrder = 0,
    required this.createdAt,
  });

  String get durationFormatted {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) return '${hours}h';
      return '${hours}h ${minutes}min';
    }
    return '${durationMinutes}min';
  }

  String get priceFormatted {
    if (price == 0) return 'Free';
    return '\$${price.toStringAsFixed(2)}';
  }

  String get locationTypeLabel {
    switch (locationType) {
      case ServiceLocationType.online:
        return 'Online';
      case ServiceLocationType.atLocation:
        return 'At our location';
      case ServiceLocationType.atClientAddress:
        return 'At your address';
      case ServiceLocationType.both:
        return 'Online or in-person';
    }
  }

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      providerId: data['providerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      durationMinutes: data['durationMinutes'] ?? 60,
      price: (data['price'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'USD',
      locationType: ServiceLocationType.values.firstWhere(
        (e) => e.name == data['locationType'],
        orElse: () => ServiceLocationType.atLocation,
      ),
      isActive: data['isActive'] ?? true,
      bufferTimeMinutes: data['bufferTimeMinutes'] ?? 0,
      imageUrl: data['imageUrl'],
      sortOrder: data['sortOrder'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'providerId': providerId,
      'name': name,
      'description': description,
      'durationMinutes': durationMinutes,
      'price': price,
      'currency': currency,
      'locationType': locationType.name,
      'isActive': isActive,
      'bufferTimeMinutes': bufferTimeMinutes,
      'imageUrl': imageUrl,
      'sortOrder': sortOrder,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
