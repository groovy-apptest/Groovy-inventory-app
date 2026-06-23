import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';
import 'package:groovy_inventory/core/widgets/app_search_box.dart';
import 'package:groovy_inventory/features/inventory/providers/inventory_provider.dart';
import 'package:groovy_inventory/features/inventory/widgets/material_group_filters.dart';
import 'package:groovy_inventory/features/inventory/widgets/stock_card.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  Future<void> _refreshInventory() async {
    ref.invalidate(inventoryStocksProvider);
    ref.invalidate(materialGroupsProvider);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final asyncStocks = ref.watch(inventoryStocksProvider);
    final selectedView = ref.watch(selectedInventoryStockViewProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Inventory',
        bottomText: 'Stock levels & alerts',
        actions: [
          PopupMenuButton<InventoryStockView>(
            initialValue: selectedView,
            tooltip: 'Filter stock',
            icon: const Icon(Icons.filter_list_rounded),
            onSelected: (value) {
              ref.read(selectedInventoryStockViewProvider.notifier).set(value);
            },
            itemBuilder: (context) => InventoryStockView.values.map((view) {
              return PopupMenuItem<InventoryStockView>(
                value: view,
                child: Row(
                  children: [
                    Icon(
                      selectedView == view
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: selectedView == view
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(view.label),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: AppSearchBox(
              onSearch: (value) {
                ref.read(inventorySearchQueryProvider.notifier).set(value);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: MaterialGroupFilters(),
          ),
          Expanded(
            child: asyncStocks.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load ${selectedView.label.toLowerCase()}',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              data: (stocks) {
                if (stocks.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshInventory,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Text(
                            'No ${selectedView.label.toLowerCase()} found',
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshInventory,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: stocks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return StockCard(stock: stocks[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
