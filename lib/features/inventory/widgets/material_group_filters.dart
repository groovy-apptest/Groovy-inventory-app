import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/inventory/providers/inventory_provider.dart';

class MaterialGroupFilters extends ConsumerWidget {
  const MaterialGroupFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(materialGroupsProvider);

    final selectedFilter = ref.watch(selectedGroupFilterProvider);

    return groupsAsync.when(
      loading: () => const SizedBox(
        height: 38,
        child: Center(child: CircularProgressIndicator()),
      ),

      error: (error, _) =>
          SizedBox(height: 38, child: Center(child: Text(error.toString()))),

      data: (groups) {
        final filters = [
          (label: 'All', value: null),
          ...groups.map((group) => (label: group, value: group)),
        ];

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,

            itemCount: filters.length,

            separatorBuilder: (_, _) => const SizedBox(width: 8),

            itemBuilder: (context, index) {
              final filter = filters[index];

              final isSelected = selectedFilter == filter.value;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedGroupFilterProvider.notifier)
                      .set(filter.value);
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),

                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.card,

                    borderRadius: BorderRadius.circular(20),

                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                  ),

                  alignment: Alignment.center,

                  child: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
