# Mughal Tech OU — Booking App Setup Guide

## For Developers: Getting Started

### Step 1 — Install Dependencies
```bash
flutter pub get
```

### Step 2 — Firebase Setup
1. Go to https://console.firebase.google.com
2. Create a new project called "mughal-tech-booking"
3. Enable these services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
4. Add an Android app (package: com.mughaltech.booking)
5. Download `google-services.json` and place it in `android/app/`
6. Add a Web app for the web version
7. Copy the web config into `lib/firebase_options.dart` (use FlutterFire CLI)

### Step 3 — FlutterFire CLI (recommended)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This auto-generates `lib/firebase_options.dart` and wires everything up.

### Step 4 — Update main.dart
After FlutterFire configure, update main.dart:
```dart
import 'firebase_options.dart';
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### Step 5 — Firestore Security Rules
In Firebase Console > Firestore > Rules, paste:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /providers/{providerId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == providerId;
    }
    match /services/{serviceId} {
      allow read: if true;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.providerId;
    }
    match /bookings/{bookingId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.providerId;
      allow create: if true; // clients can create bookings
      allow update: if request.auth != null;
    }
    match /availability/{providerId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == providerId;
    }
  }
}
```

### Step 6 — Stripe Setup (for subscriptions)
1. Create account at https://stripe.com
2. Get your API keys from Stripe Dashboard
3. Update `lib/config/app_config.dart`:
   - `stripePublishableKey`
   - `stripeSecretKey`
   - `stripeMonthlyPriceId` (create a $5/month product in Stripe)

### Step 7 — Run the App
```bash
# Android
flutter run

# Web
flutter run -d chrome

# Build for release
flutter build apk --release        # Android
flutter build web --release         # Web
```

---

## Customisation (No coding required)

All customisable values are in ONE file: `lib/config/app_config.dart`

Change any of these without touching other files:
- App name
- Subscription price
- Trial period length
- Business categories
- Brand colours
- Admin emails
- Support email

---

## Project Structure

```
lib/
├── config/
│   ├── app_config.dart     ← ALL customisable settings
│   ├── theme.dart          ← Visual theme
│   └── routes.dart         ← Navigation
├── models/                 ← Data structures
├── providers/              ← State management
├── screens/
│   ├── auth/               ← Login, Register
│   ├── provider/           ← Provider dashboard
│   ├── booking/            ← Client booking flow
│   └── admin/              ← Super admin panel
├── services/               ← Firebase & business logic
├── utils/                  ← Validators & helpers
└── widgets/                ← Reusable UI components
```

---

## Questions?
Contact: support@mughaltech.com
