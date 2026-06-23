import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/core/utils/app_logger.dart';
import 'package:groovy_inventory/features/auth/screens/login_screen.dart';
import 'package:groovy_inventory/features/inventory/screens/inventory_detail_screen.dart';
import 'package:groovy_inventory/features/profile/screens/change_password_screen.dart';
import 'package:groovy_inventory/features/splash/screens/splash_screen.dart';
import 'package:groovy_inventory/features/dashboard/screens/dashboard_screen.dart';
import 'package:groovy_inventory/features/inventory/screens/inventory_screen.dart';
import 'package:groovy_inventory/features/transactions/screens/transactions_screen.dart';
import 'package:groovy_inventory/features/inventory/screens/adjustment_screen.dart';
import 'package:groovy_inventory/features/profile/screens/profile_screen.dart';
import 'shell_scaffold.dart';

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    observers: [_LoggingObserver(), CNTabBarRouteObserver()],
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/adjustment',
        builder: (context, state) => const AdjustmentScreen(),
      ),
      GoRoute(
        path: '/inventory/:id',
        builder: (context, state) {
          final materialId = state.pathParameters['id']!;
          return InventoryDetailScreen(materailId: materialId);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/inventory',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InventoryScreen()),
          ),
          GoRoute(
            path: '/transactions',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TransactionsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}

class _LoggingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.d('Navigate to: ${route.settings.name}');
  }
}
