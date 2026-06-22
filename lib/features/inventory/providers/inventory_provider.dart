import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';
import 'package:groovy_inventory/features/inventory/repository/inventory_repository.dart';

final inventoryRepoProvider = Provider((ref) => InventoryRepository());

final materialsProvider =
    AsyncNotifierProvider<MaterialsNotifier, List<MaterialModel>>(
      MaterialsNotifier.new,
    );

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
