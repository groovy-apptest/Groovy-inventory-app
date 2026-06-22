import 'package:groovy_inventory/core/network/api_client.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';

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
}
