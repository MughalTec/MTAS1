// ============================================================
// APP CONFIGURATION — Edit this file to change app settings
// No other files need to be touched for basic customization
// ============================================================

class AppConfig {
  // ---- App Identity ----
  static const String appName = 'Mughal Tech OU';
  static const String appTagline = 'Online booking system for service professionals';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@mughaltech.com';
  static const String websiteUrl = 'https://mughaltech.com';

  // ---- Subscription Pricing ----
  static const double subscriptionPriceMonthly = 5.0;
  static const double subscriptionPriceYearly = 48.0; // 2 months free
  static const String currency = 'USD';
  static const String currencySymbol = '\$';
  static const int trialDays = 14;

  // ---- Stripe ----
  // Replace with your actual Stripe keys from stripe.com
  static const String stripePublishableKey = 'pk_test_YOUR_STRIPE_KEY_HERE';
  static const String stripeSecretKey = 'sk_test_YOUR_STRIPE_SECRET_HERE';
  static const String stripeMonthlyPriceId = 'price_YOUR_MONTHLY_PRICE_ID';
  static const String stripeYearlyPriceId = 'price_YOUR_YEARLY_PRICE_ID';

  // ---- Firebase ----
  // Firebase config is handled in google-services.json (Android)
  // and GoogleService-Info.plist (iOS) — provided by your Firebase project

  // ---- App Colors (hex values) ----
  // Primary brand color — change this to match your brand
  static const int primaryColorHex = 0xFF1E3A5F;       // Deep navy blue
  static const int secondaryColorHex = 0xFF2ECC71;     // Fresh green (accent)
  static const int backgroundColorHex = 0xFFF8F9FA;    // Light grey background
  static const int cardColorHex = 0xFFFFFFFF;          // White cards
  static const int errorColorHex = 0xFFE74C3C;         // Red for errors
  static const int textPrimaryHex = 0xFF2C3E50;        // Dark text
  static const int textSecondaryHex = 0xFF7F8C8D;      // Grey text

  // ---- Business Categories (shown during provider onboarding) ----
  static const List<String> businessCategories = [
    'Medical Clinic',
    'Dental Practice',
    'Beauty Salon',
    'Barbershop',
    'Spa & Wellness',
    'Physiotherapy',
    'Coaching & Consulting',
    'Personal Training',
    'Tutoring',
    'Legal Services',
    'Therapy & Counselling',
    'Veterinary',
    'Other',
  ];

  // ---- Booking Settings ----
  static const int maxAdvanceBookingDays = 60;  // How far ahead clients can book
  static const int minBookingNoticeMinutes = 60; // Minimum notice before booking
  static const List<int> bufferTimeOptions = [0, 5, 10, 15, 30]; // in minutes
  static const List<int> durationOptions = [15, 30, 45, 60, 90, 120]; // in minutes

  // ---- Admin ----
  // Email addresses that have super admin access
  static const List<String> adminEmails = [
    'admin@mughaltech.com',
    // Add more admin emails here
  ];
}
