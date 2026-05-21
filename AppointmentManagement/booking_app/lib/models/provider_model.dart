class ProviderModel {

  final String id;
  final String name;
  final String email;
  final String phone;

  final String businessName;
  final String businessCategory;
  final String businessDescription;

  final String? businessLogoUrl;

  final String bookingPageSlug;

  final bool isActive;
 /* final bool is_subscribed;
  final String subscription_status;*/

  final DateTime createdAt;

  ProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessCategory,
    required this.businessDescription,
    this.businessLogoUrl,
    required this.bookingPageSlug,
    required this.isActive,
   /* required this.is_subscribed,
    required this.subscription_status,*/
    required this.createdAt,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      businessName: json['business_name'] ?? '',
      businessCategory: json['business_category'] ?? '',
      businessDescription: json['business_description'] ?? '',
      bookingPageSlug: json['booking_page_slug'] ?? '',
      isActive: json['is_active'] ?? true,
     /* isSubscribed: json['is_subscribed'] ?? false,
      subscriptionStatus: json['subscription_status'] ?? 'trial',*/
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}