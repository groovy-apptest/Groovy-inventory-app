import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/core/utils/app_date_time.dart';
import 'package:groovy_inventory/features/inventory/models/stock_model.dart';

class StockCard extends StatelessWidget {
  const StockCard({super.key, required this.stock});

  final StockModel stock;

  @override
  Widget build(BuildContext context) {
    final minimumStock = stock.minimumStock ?? 0;
    final progress = minimumStock <= 0
        ? 1.0
        : (stock.currentStock / minimumStock).clamp(0.0, 1.0);
    final isOutOfStock = stock.currentStock <= 0;
    final isBelowMinimum =
        minimumStock > 0 && stock.currentStock < minimumStock;
    final statusLabel = isOutOfStock
        ? 'Out of Stock'
        : isBelowMinimum
        ? 'Below Minimum'
        : 'In Stock';
    final statusColor = isOutOfStock || isBelowMinimum
        ? AppColors.error
        : AppColors.success;

    return InkWell(
      onTap: () {
        context.push('/inventory/${stock.materialId}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.materialName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StockMetric(
                    label: 'CURRENT',
                    value: _formatNumber(stock.currentStock),
                  ),
                ),
                Expanded(
                  child: _StockMetric(
                    label: 'MINIMUM',
                    value: _formatNumber(minimumStock),
                  ),
                ),
                Expanded(
                  child: _StockMetric(label: 'UOM', value: stock.uom ?? '-'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.22),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _updatedText,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final group = stock.materialGroup;
    if (group == null || group.isEmpty) return stock.materialCode;
    return '${stock.materialCode} · $group';
  }

  String get _updatedText {
    final updatedAt = stock.lastUpdated;
    if (updatedAt == null) return 'Updated recently';
    return 'Updated ${AppDateTime.timeAgo(updatedAt)}';
  }

  static String _formatNumber(double value) {
    if (value.truncateToDouble() == value) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }
}

class _StockMetric extends StatelessWidget {
  const _StockMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
