import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/provider/dashboard_screen.dart';
import '../screens/booking/booking_page_screen.dart';
import '../screens/booking/select_time_screen.dart';
import '../screens/booking/client_details_screen.dart';
import '../screens/booking/confirmation_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../models/provider_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';

class AppRouter {
  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.status == AuthStatus.authenticated;
        final isLoading = authProvider.status == AuthStatus.unknown;

        if (isLoading) return null;

        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Public booking routes — always accessible
        if (state.matchedLocation.startsWith('/book/')) return null;

        if (!isAuthenticated && !isAuthRoute) return '/login';
        if (isAuthenticated && isAuthRoute) return '/dashboard';

        return null;
      },
      routes: [
        // Auth
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Provider Dashboard
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),

        // Admin
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),

        // Public Booking Flow
        GoRoute(
          path: '/book/:slug',
          builder: (context, state) => BookingPageScreen(
            slug: state.pathParameters['slug']!,
          ),
        ),
        GoRoute(
          path: '/book/:slug/select-time',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return SelectTimeScreen(
              provider: extra['provider'] as ProviderModel,
              service: extra['service'] as ServiceModel,
            );
          },
        ),
        GoRoute(
          path: '/book/:slug/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ClientDetailsScreen(
              provider: extra['provider'] as ProviderModel,
              service: extra['service'] as ServiceModel,
              selectedSlot: extra['selectedSlot'] as DateTime,
            );
          },
        ),
        GoRoute(
          path: '/book/:slug/confirmation',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ConfirmationScreen(
              booking: extra['booking'] as BookingModel,
              provider: extra['provider'] as ProviderModel,
            );
          },
        ),
      ],
      initialLocation: '/login',
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    );
  }
}
