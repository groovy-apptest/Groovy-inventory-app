class LowStockItemModel {
  final String id;
  final String materialId;

  final double currentStock;
  final double reservedStock;
  final double availableStock;

  final DateTime? lastTransactionDate;
  final DateTime lastUpdated;

  final String materialCode;
  final String materialName;
  final String materialGroup;
  final String uom;

  final double minimumStock;

  const LowStockItemModel({
    required this.id,
    required this.materialId,
    required this.currentStock,
    required this.reservedStock,
    required this.availableStock,
    required this.lastTransactionDate,
    required this.lastUpdated,
    required this.materialCode,
    required this.materialName,
    required this.materialGroup,
    required this.uom,
    required this.minimumStock,
  });

  factory LowStockItemModel.fromJson(Map<String, dynamic> json) {
    return LowStockItemModel(
      id: json['id'] ?? '',
      materialId: json['materialId'] ?? '',

      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0,

      reservedStock: (json['reservedStock'] as num?)?.toDouble() ?? 0,

      availableStock: (json['availableStock'] as num?)?.toDouble() ?? 0,

      lastTransactionDate: json['lastTransactionDate'] != null
          ? DateTime.parse(json['lastTransactionDate'])
          : null,

      lastUpdated: DateTime.parse(json['lastUpdated']),

      materialCode: json['materialCode'] ?? '',

      materialName: json['materialName'] ?? '',

      materialGroup: json['materialGroup'] ?? '',

      uom: json['uom'] ?? '',

      minimumStock: (json['minimumStock'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialId': materialId,
      'currentStock': currentStock,
      'reservedStock': reservedStock,
      'availableStock': availableStock,
      'lastTransactionDate': lastTransactionDate?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'materialCode': materialCode,
      'materialName': materialName,
      'materialGroup': materialGroup,
      'uom': uom,
      'minimumStock': minimumStock,
    };
  }

  bool get isOutOfStock => currentStock <= 0;

  double get shortage => minimumStock - currentStock;

  double get stockPercentage =>
      minimumStock == 0 ? 0 : (currentStock / minimumStock) * 100;
}
