import 'package:groovy_inventory/core/network/api_client.dart';
import 'package:groovy_inventory/features/transactions/models/transaction_history_model.dart';

class TransactionsRepository {
  Future<({List<TransactionHistoryModel> transactions, int total})> getHistory({
    String? transactionType,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (transactionType != null) queryParams['transactionType'] = transactionType;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await api.get<Map<String, dynamic>>(
      '/inventory/history',
      queryParameters: queryParams,
      fromData: (json) => json as Map<String, dynamic>,
    );

    if (!response.success) throw Exception(response.message);

    final data = response.data!;
    final txns = (data['transactions'] as List)
        .map((e) => TransactionHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (transactions: txns, total: data['total'] as int);
  }
}
