import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/features/dashboard/models/low_stock_item_model.dart';
import 'package:groovy_inventory/features/dashboard/models/recent_transaction_model.dart';
import 'package:groovy_inventory/features/dashboard/repository/dashboard_repository.dart';

final _repo = Provider((ref) => DashboardRepository());

final recentTransactionsProvider =
    AsyncNotifierProvider<RecentTransactionsNotifier, List<TransactionModel>>(
      RecentTransactionsNotifier.new,
    );

class RecentTransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() =>
      ref.read(_repo).getRecentTransactions();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(_repo).getRecentTransactions());
  }
}

final lowStockItemsProvider =
    AsyncNotifierProvider<LowStockItemsNotifier, List<LowStockItemModel>>(
      LowStockItemsNotifier.new,
    );

class LowStockItemsNotifier extends AsyncNotifier<List<LowStockItemModel>> {
  @override
  Future<List<LowStockItemModel>> build() =>
      ref.read(_repo).getLowStockItems();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(_repo).getLowStockItems());
  }
}
