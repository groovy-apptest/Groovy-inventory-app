import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/dashboard/models/recent_transaction_model.dart';
import 'package:groovy_inventory/features/dashboard/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(recentTransactionsProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                context.push('/transactions');
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primaryVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        asyncTransactions.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Failed to load transactions',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text('No recent transactions'),
              );
            }
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => Divider(
                  height: 2,
                  indent: 0,
                  endIndent: 0,
                  color: AppColors.outlineVariant.withValues(alpha: 1.4),
                ),
                itemBuilder: (context, index) =>
                    _TransactionTile(transaction: transactions[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig(transaction.transactionType);
    final sign = config.isPositive ? '+' : '-';
    final dateStr = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(transaction.transactionDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '$sign${transaction.quantity.toStringAsFixed(transaction.quantity.truncateToDouble() == transaction.quantity ? 0 : 2)} ${transaction.uom}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: config.color,
                        ),
                      ),
                      TextSpan(
                        text: '  ${transaction.materialName}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateStr • ${transaction.createdByName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: AppColors.outlineVariant,
            size: 20,
          ),
        ],
      ),
    );
  }

  _TypeConfig _getTypeConfig(String type) {
    return switch (type) {
      'RECEIPT' => _TypeConfig(
        icon: Icons.arrow_downward_rounded,
        color: AppColors.success,
        isPositive: true,
      ),
      'CONSUMPTION' => _TypeConfig(
        icon: Icons.arrow_upward_rounded,
        color: AppColors.error,
        isPositive: false,
      ),
      'ADJUSTMENT_IN' => _TypeConfig(
        icon: Icons.tune_rounded,
        color: const Color(0xFFF59E0B),
        isPositive: true,
      ),
      'ADJUSTMENT_OUT' => _TypeConfig(
        icon: Icons.tune_rounded,
        color: const Color(0xFFF59E0B),
        isPositive: false,
      ),
      'OPENING' => _TypeConfig(
        icon: Icons.inventory_2_outlined,
        color: AppColors.primary,
        isPositive: true,
      ),
      _ => _TypeConfig(
        icon: Icons.swap_horiz,
        color: AppColors.onSurfaceVariant,
        isPositive: true,
      ),
    };
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  final bool isPositive;

  const _TypeConfig({
    required this.icon,
    required this.color,
    required this.isPositive,
  });
}
