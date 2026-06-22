import 'package:groovy_inventory/core/network/api_client.dart';
import 'package:groovy_inventory/features/dashboard/models/low_stock_item_model.dart';
import 'package:groovy_inventory/features/dashboard/models/recent_transaction_model.dart';

class DashboardRepository {
  Future<List<TransactionModel>> getRecentTransactions() async {
    final response = await api.get<List<TransactionModel>>(
      '/dashboard/recent-transactions?limit=5',
      fromData: (json) {
        return (json as List)
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data ?? [];
  }

  Future<List<LowStockItemModel>> getLowStockItems() async {
    final response = await api.get<List<LowStockItemModel>>(
      '/dashboard/low-stock',
      fromData: (json) {
        return (json as List)
            .map((e) => LowStockItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data ?? [];
  }
}
