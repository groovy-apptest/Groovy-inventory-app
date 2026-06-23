import 'package:groovy_inventory/core/network/api_client.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';
import 'package:groovy_inventory/features/inventory/models/stock_model.dart';

class InventoryRepository {
  Future<List<MaterialModel>> getMaterials({String? search}) async {
    final params = <String, dynamic>{'isActive': true, 'limit': 100};
    if (search != null && search.isNotEmpty) params['search'] = search;

    final response = await api.get<Map<String, dynamic>>(
      '/materials/',
      queryParameters: params,
      fromData: (json) => json as Map<String, dynamic>,
    );

    if (!response.success) throw Exception(response.message);

    return (response.data!['materials'] as List)
        .map((e) => MaterialModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> getNextReferenceNo() async {
    final response = await api.get<String>(
      '/inventory/next-reference-no',
      fromData: (json) => json as String,
    );
    if (!response.success) throw Exception(response.message);
    return response.data!;
  }

  Future<void> recordAdjustment({
    required String materialId,
    required String adjustmentType,
    required double quantity,
    required String referenceNo,
    required String remarks,
  }) async {
    final response = await api.post(
      '/inventory/adjustment',
      data: {
        'materialId': materialId,
        'adjustmentType': adjustmentType,
        'quantity': quantity,
        'referenceNo': referenceNo,
        'remarks': remarks,
      },
    );
    if (!response.success) throw Exception(response.message);
  }

  Future<List<String>> getMaterialGroups() async {
    final response = await api.get<List<String>>(
      '/materials/groups',
      fromData: (json) => List<String>.from(json),
    );

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data ?? [];
  }


  Future<StockModel> getStock(
  String materialId,
) async {
  final response = await api.get<StockModel>(
    '/inventory/stocks/$materialId',
    fromData: (json) => StockModel.fromJson(
      json as Map<String, dynamic>,
    ),
  );

  if (!response.success) {
    throw Exception(response.message);
  }

  if (response.data == null) {
    throw Exception('Stock not found');
  }

  return response.data!;
}

  Future<List<StockModel>> getStocks({
    String? search,
    String? group,
    String endpoint = '/inventory/stocks',
  }) async {
    final response = await api.get<List<StockModel>>(
      endpoint,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (group != null && group.isNotEmpty) 'group': group,
      },
      fromData: (json) {
        return (json as List)
            .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data ?? [];
  }
}
