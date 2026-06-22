import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';
import 'package:groovy_inventory/features/auth/providers/auth_provider.dart';
import 'package:groovy_inventory/features/dashboard/widgets/quick_actions.dart';
import 'package:groovy_inventory/features/dashboard/widgets/low_stock_alerts.dart';
import 'package:groovy_inventory/features/dashboard/widgets/recent_transactions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: CustomAppBar(
        topText: 'Welcome back',
        title: user?.name ?? 'Guest user',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: const [
          QuickActions(),
          SizedBox(height: 24),
          LowStockAlerts(),
          SizedBox(height: 24),
          RecentTransactions(),
        ],
      ),
    );
  }
}
