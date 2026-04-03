import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_insights_screen.dart';
import '../../features/auth/presentation/authentication_screen.dart';
import '../../features/budgets/presentation/budget_management_screen.dart';
import '../../features/home/presentation/home_dashboard.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_settings_screen.dart';
import '../../features/transactions/presentation/add_transaction_screen.dart';
import '../../features/transactions/presentation/transactions_list_screen.dart';
import '../services/auth_service.dart';
import 'route_names.dart';

/// Builds the app-wide GoRouter configuration.
GoRouter createAppRouter(AuthService authService) {
  return GoRouter(
    initialLocation: RouteNames.onboarding,
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges()),
    redirect: (context, state) {
      final isSignedIn = authService.currentUser != null;
      final location = state.matchedLocation;
      final isAuthRoute =
          location == RouteNames.auth || location == RouteNames.onboarding;

      if (!isSignedIn && !isAuthRoute) {
        return RouteNames.auth;
      }

      if (isSignedIn && isAuthRoute) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.auth,
        builder: (context, state) => const AuthenticationScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeDashboard(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.transactions,
                builder: (context, state) => const TransactionsListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.addTransaction,
                builder: (context, state) => const AddTransactionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.insights,
                builder: (context, state) => const AnalyticsInsightsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.budgets,
                builder: (context, state) => const BudgetManagementScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
    ],
  );
}

/// Simple adapter to let GoRouter refresh from a stream.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
