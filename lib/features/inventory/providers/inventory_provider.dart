import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';
import 'package:groovy_inventory/features/inventory/models/stock_model.dart';
import 'package:groovy_inventory/features/inventory/repository/inventory_repository.dart';
import 'package:riverpod/src/framework.dart';

final inventoryRepoProvider = Provider((ref) => InventoryRepository());

final materialsProvider =
    AsyncNotifierProvider<MaterialsNotifier, List<MaterialModel>>(
      MaterialsNotifier.new,
    );

final inventorySearchQueryProvider =
    NotifierProvider<InventorySearchQueryNotifier, String?>(
      InventorySearchQueryNotifier.new,
    );

class InventorySearchQueryNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? value) => state = value;
}

enum InventoryStockView {
  all('All', '/inventory/stocks'),
  lowStock('Low Stock', '/inventory/stocks/low-stock'),
  alerts('Alert', '/inventory/alerts');

  const InventoryStockView(this.label, this.endpoint);

  final String label;
  final String endpoint;
}

final selectedInventoryStockViewProvider =
    NotifierProvider<SelectedInventoryStockViewNotifier, InventoryStockView>(
      SelectedInventoryStockViewNotifier.new,
    );

class SelectedInventoryStockViewNotifier extends Notifier<InventoryStockView> {
  @override
  InventoryStockView build() => InventoryStockView.all;

  void set(InventoryStockView value) => state = value;
}

final inventoryStocksProvider =
    AsyncNotifierProvider<InventoryStocksNotifier, List<StockModel>>(
      InventoryStocksNotifier.new,
    );

class InventoryStocksNotifier extends AsyncNotifier<List<StockModel>> {
  @override
  Future<List<StockModel>> build() {
    final search = ref.watch(inventorySearchQueryProvider);
    final group = ref.watch(selectedGroupFilterProvider);
    final view = ref.watch(selectedInventoryStockViewProvider);
    return ref
        .read(inventoryRepoProvider)
        .getStocks(search: search, group: group, endpoint: view.endpoint);
  }
}


class MaterialsNotifier extends AsyncNotifier<List<MaterialModel>> {
  @override
  Future<List<MaterialModel>> build() =>
      ref.read(inventoryRepoProvider).getMaterials();

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(inventoryRepoProvider).getMaterials(search: query),
    );
  }
}

final materialGroupsProvider =
    AsyncNotifierProvider<MaterialGroupsNotifier, List<String>>(
      MaterialGroupsNotifier.new,
    );

class MaterialGroupsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    return _fetch();
  }

  Future<List<String>> _fetch() {
    return ref.read(inventoryRepoProvider).getMaterialGroups();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final selectedGroupFilterProvider =
    NotifierProvider<SelectedGroupFilterNotifier, String?>(
      SelectedGroupFilterNotifier.new,
    );

class SelectedGroupFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}
