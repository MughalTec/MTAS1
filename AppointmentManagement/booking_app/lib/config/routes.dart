import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/complete_profile_screen.dart';

import '../screens/provider/dashboard_screen.dart';

import '../screens/booking/booking_page_screen.dart';
import '../screens/booking/select_time_screen.dart';
import '../screens/booking/confirmation_screen.dart';

import '../screens/admin/admin_dashboard_screen.dart';

import '../screens/booking/services_screen.dart';

import '../screens/booking/booking_calendar_screen.dart';

import '../models/provider_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';

class AppRouter {

  static GoRouter router(
      AuthProvider authProvider
      ) {

    return GoRouter(

      initialLocation: '/login',

      refreshListenable: authProvider,

      // =====================================
      // REDIRECT
      // =====================================

      redirect: (context, state) {

        final isAuth =
            authProvider.status ==
                AuthStatus.authenticated;

        final isLoading =
            authProvider.status ==
                AuthStatus.unknown;

        if (isLoading) {
          return null;
        }

        final location =
            state.matchedLocation;

        final isAuthRoute =
            location == '/login' ||
                location ==
                    '/complete-profile';

        // =====================================
        // PUBLIC ROUTES
        // =====================================

        if (
        location.startsWith('/book/')
        ) {
          return null;
        }

        // =====================================
        // NOT LOGGED IN
        // =====================================

        if (!isAuth && !isAuthRoute) {
          return '/login';
        }

        return null;
      },

      // =====================================
      // ROUTES
      // =====================================

      routes: [

        // =====================================
        // LOGIN
        // =====================================

        GoRoute(

          path: '/login',

          builder: (context, state) =>
          const LoginScreen(),
        ),

        // =====================================
        // COMPLETE PROFILE
        // =====================================

        GoRoute(

          path: '/complete-profile',

          builder: (context, state) =>
          const CompleteProfileScreen(),
        ),

        // =====================================
        // DASHBOARD
        // =====================================

        GoRoute(

          path: '/dashboard',

          builder: (context, state) =>
          const DashboardScreen(),
        ),

        // =====================================
        // SERVICES
        // =====================================

        GoRoute(

          path: '/services',

          builder: (context, state) =>
          const ServicesScreen(),
        ),

        // =====================================
        // PUBLIC BOOKING PAGE
        // =====================================

        /*GoRoute(

          path: '/book/:slug',

          builder: (context, state) {

            final slug =
            state.pathParameters['slug']!;

            return BookingPageScreen(
              slug: slug,
            );
          },
        ),*/

        // =====================================
        // SELECT TIME
        // =====================================

        GoRoute(

          path: '/book/:slug/select-time',

          builder: (context, state) {

            final extra =
            state.extra
            as Map<String, dynamic>;

            return SelectTimeScreen(

              provider:
              extra['provider']
              as ProviderModel,

              service:
              extra['service']
              as ServiceModel,
            );
          },
        ),

        // =====================================
        // CONFIRMATION
        // =====================================

      /*  GoRoute(

          path: '/confirmation',

          builder: (context, state) {

            final booking =
            state.extra
            as BookingModel;

            return ConfirmationScreen(
              booking: booking,
            );
          },
        ),*/

        // =====================================
        // BOOKING CALENDAR
        // =====================================

        GoRoute(
          path: '/booking-calendar',
          builder: (context, state) {

            final provider =
            state.extra as ProviderModel?;

            if (provider == null) {
              return const Scaffold(
                body: Center(
                  child: Text("No provider found. Please login again."),
                ),
              );
            }

            return BookingCalendarScreen(
              provider: provider,
            );
          },
        ),

        // =====================================
        // ADMIN
        // =====================================

       /* GoRoute(

          path: '/admin',

          builder: (context, state) =>
          const AdminDashboardScreen(),
        ),*/
      ],

      // =====================================
      // ERROR
      // =====================================

      errorBuilder: (context, state) {

        return Scaffold(

          body: Center(

            child: Text(
              'Page not found: ${state.error}',
            ),
          ),
        );
      },
    );
  }
}