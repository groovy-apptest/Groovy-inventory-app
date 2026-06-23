import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';
import 'package:groovy_inventory/features/auth/providers/auth_provider.dart';
import 'package:groovy_inventory/features/dashboard/providers/dashboard_provider.dart';
import 'package:groovy_inventory/features/dashboard/widgets/quick_actions.dart';
import 'package:groovy_inventory/features/dashboard/widgets/low_stock_alerts.dart';
import 'package:groovy_inventory/features/dashboard/widgets/recent_transactions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

   Future<void> _refreshDashboard(WidgetRef ref) async {
    ref.invalidate(lowStockItemsProvider);
    ref.invalidate(recentTransactionsProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: CustomAppBar(
        topText: 'Welcome back',
        title: user?.name ?? 'Guest user',
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDashboard(ref),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: const [
            QuickActions(),
            SizedBox(height: 24),
            LowStockAlerts(),
            SizedBox(height: 24),
            RecentTransactions(),
          ],
        ),
      ),
    );
  }
}
