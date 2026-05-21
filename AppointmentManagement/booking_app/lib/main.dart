import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'config/routes.dart';

import 'providers/auth_provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAMlLOUFEfXNzjx1lj5gJw03OiPJfy0H4I",
        authDomain: "mtas-booking.firebaseapp.com",
        projectId: "mtas-booking",
        storageBucket: "mtas-booking.firebasestorage.app",
        messagingSenderId: "992988980450",
        appId: "1:992988980450:web:7e03917abd079cd4906abb"
    ),
  );

  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {

  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],

      child: Builder(
        builder: (context) {

          final authProvider =
          context.watch<AuthProvider>();

          return MaterialApp.router(

            debugShowCheckedModeBanner: false,

            title: 'Booking App',

            theme: AppTheme.lightTheme,

            routerConfig:
            AppRouter.router(authProvider),
          );
        },
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'config/theme.dart';
import 'config/routes.dart';

import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(),
        ),
      ],

      child: Builder(
        builder: (context) {
          final authProvider =
          context.watch<AuthProvider>();

          return MaterialApp.router(
            title: 'Booking App',
            theme: AppTheme.lightTheme,
            routerConfig:
            AppRouter.router(authProvider),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}*/
