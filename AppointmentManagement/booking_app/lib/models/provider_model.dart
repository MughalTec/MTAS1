import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String businessCategory;
  final String businessDescription;
  final String? profileImageUrl;
  final String? businessLogoUrl;
  final String bookingPageSlug; // unique URL slug e.g. "dr-smith-dental"
  final bool isActive;
  final bool isSubscribed;
  final String subscriptionStatus; // 'trial', 'active', 'expired', 'cancelled'
  final DateTime? trialEndsAt;
  final DateTime? subscriptionEndsAt;
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;
  final Map<String, dynamic> settings;
  final DateTime createdAt;

  ProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessCategory,
    required this.businessDescription,
    this.profileImageUrl,
    this.businessLogoUrl,
    required this.bookingPageSlug,
    this.isActive = true,
    this.isSubscribed = false,
    this.subscriptionStatus = 'trial',
    this.trialEndsAt,
    this.subscriptionEndsAt,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.settings = const {},
    required this.createdAt,
  });

  bool get isOnTrial => subscriptionStatus == 'trial' &&
      trialEndsAt != null &&
      trialEndsAt!.isAfter(DateTime.now());

  bool get hasActiveAccess =>
      subscriptionStatus == 'active' || isOnTrial;

  factory ProviderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProviderModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      businessName: data['businessName'] ?? '',
      businessCategory: data['businessCategory'] ?? '',
      businessDescription: data['businessDescription'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      businessLogoUrl: data['businessLogoUrl'],
      bookingPageSlug: data['bookingPageSlug'] ?? '',
      isActive: data['isActive'] ?? true,
      isSubscribed: data['isSubscribed'] ?? false,
      subscriptionStatus: data['subscriptionStatus'] ?? 'trial',
      trialEndsAt: data['trialEndsAt'] != null
          ? (data['trialEndsAt'] as Timestamp).toDate()
          : null,
      subscriptionEndsAt: data['subscriptionEndsAt'] != null
          ? (data['subscriptionEndsAt'] as Timestamp).toDate()
          : null,
      stripeCustomerId: data['stripeCustomerId'],
      stripeSubscriptionId: data['stripeSubscriptionId'],
      settings: data['settings'] ?? {},
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'businessName': businessName,
      'businessCategory': businessCategory,
      'businessDescription': businessDescription,
      'profileImageUrl': profileImageUrl,
      'businessLogoUrl': businessLogoUrl,
      'bookingPageSlug': bookingPageSlug,
      'isActive': isActive,
      'isSubscribed': isSubscribed,
      'subscriptionStatus': subscriptionStatus,
      'trialEndsAt': trialEndsAt != null ? Timestamp.fromDate(trialEndsAt!) : null,
      'subscriptionEndsAt': subscriptionEndsAt != null
          ? Timestamp.fromDate(subscriptionEndsAt!)
          : null,
      'stripeCustomerId': stripeCustomerId,
      'stripeSubscriptionId': stripeSubscriptionId,
      'settings': settings,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ProviderModel copyWith({
    String? name,
    String? phone,
    String? businessName,
    String? businessCategory,
    String? businessDescription,
    String? profileImageUrl,
    String? businessLogoUrl,
    bool? isActive,
    bool? isSubscribed,
    String? subscriptionStatus,
    Map<String, dynamic>? settings,
  }) {
    return ProviderModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      businessCategory: businessCategory ?? this.businessCategory,
      businessDescription: businessDescription ?? this.businessDescription,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessLogoUrl: businessLogoUrl ?? this.businessLogoUrl,
      bookingPageSlug: bookingPageSlug,
      isActive: isActive ?? this.isActive,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      trialEndsAt: trialEndsAt,
      subscriptionEndsAt: subscriptionEndsAt,
      stripeCustomerId: stripeCustomerId,
      stripeSubscriptionId: stripeSubscriptionId,
      settings: settings ?? this.settings,
      createdAt: createdAt,
    );
  }
}
