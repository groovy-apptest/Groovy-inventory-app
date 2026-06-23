import 'package:flutter/material.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/core/utils/app_date_time.dart';
import 'package:groovy_inventory/features/transactions/models/transaction_history_model.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});

  final TransactionHistoryModel transaction;

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig(transaction.transactionType);
    final sign = transaction.isPositive ? '+' : '−';
    final qtyStr = transaction.quantity.toStringAsFixed(
      transaction.quantity.truncateToDouble() == transaction.quantity ? 0 : 2,
    );
    final dateStr = AppDateTime.formatTransactionDate(
      transaction.transactionDate,
    );
    final createdBy = transaction.createdByName ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, color: config.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.materialName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$dateStr · $createdBy',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transaction.transactionNo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$sign$qtyStr ${transaction.uom}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: config.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
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
      ),
      'CONSUMPTION' => _TypeConfig(
        icon: Icons.arrow_upward_rounded,
        color: AppColors.error,
      ),
      'ADJUSTMENT_IN' => _TypeConfig(
        icon: Icons.tune_rounded,
        color: const Color(0xFFF59E0B),
      ),
      'ADJUSTMENT_OUT' => _TypeConfig(
        icon: Icons.tune_rounded,
        color: const Color(0xFFF59E0B),
      ),
      'OPENING' => _TypeConfig(
        icon: Icons.inventory_2_outlined,
        color: AppColors.primary,
      ),
      _ => _TypeConfig(
        icon: Icons.swap_horiz,
        color: AppColors.onSurfaceVariant,
      ),
    };
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;

  const _TypeConfig({required this.icon, required this.color});
}
