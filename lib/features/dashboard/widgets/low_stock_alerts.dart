import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/dashboard/models/low_stock_item_model.dart';
import 'package:groovy_inventory/features/dashboard/providers/dashboard_provider.dart';

class LowStockAlerts extends ConsumerWidget {
  const LowStockAlerts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(lowStockItemsProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Low Stock Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () => context.push('/inventory'),
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
        asyncItems.when(
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
                'Failed to load low stock items',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Text('No low stock alerts'),
              );
            }
            final displayItems = items.take(3).toList();
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error.withValues(alpha: 0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${items.length} material${items.length == 1 ? '' : 's'} need attention',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...displayItems.map((item) => Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: _LowStockCard(item: item),
                      )),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LowStockCard extends StatelessWidget {
  const _LowStockCard({required this.item});

  final LowStockItemModel item;

  @override
  Widget build(BuildContext context) {
    final percentage = item.stockPercentage.clamp(0, 100) / 100;
    final label = item.isOutOfStock ? 'Out of Stock' : 'Below Minimum';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.materialName,
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
                      '${item.materialCode} · ${item.materialGroup}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Current '),
                    TextSpan(
                      text: '${item.currentStock.toStringAsFixed(item.currentStock.truncateToDouble() == item.currentStock ? 0 : 1)} ${item.uom}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Min '),
                    TextSpan(
                      text: item.minimumStock.toStringAsFixed(item.minimumStock.truncateToDouble() == item.minimumStock ? 0 : 1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 5,
              backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
