import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/transactions/providers/transactions_provider.dart';

class TransactionFilters extends ConsumerWidget {
  const TransactionFilters({super.key});

  static const _filters = [
    (label: 'All', value: null),
    (label: 'Receipts', value: 'RECEIPT'),
    (label: 'Consumption', value: 'CONSUMPTION'),
    (label: 'Adjustments', value: 'ADJUSTMENT_IN'),
    (label: 'opening', value: 'OPENING'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedFilterProvider);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selected == filter.value;
          return GestureDetector(
            onTap: () => ref.read(selectedFilterProvider.notifier).set(filter.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              alignment: Alignment.center,
              child: Text(
                filter.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
