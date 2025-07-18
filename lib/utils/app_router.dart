import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto/views/notifications/notification_page.dart';
import 'package:resto/views/restaurant/master_restaurant_page.dart';
import '../providers/auth_providers.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home/home_screen.dart';
import 'constants.dart'; // Import the constants file

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangeProvider);

  return GoRouter(
    // Use the constant for the initial location
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        // Use constants for paths
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.manageRestaurant,
        builder: (context, state) => const MasterRestaurantPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authState.value != null;
      // Use constants in redirect logic
      final loggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!loggedIn &&
          !loggingIn &&
          state.matchedLocation != AppRoutes.forgotPassword) {
        return AppRoutes.login;
      }

      if (loggedIn && loggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
  );
});
