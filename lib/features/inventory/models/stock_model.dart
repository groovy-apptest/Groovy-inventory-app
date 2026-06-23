import 'package:groovy_inventory/core/utils/app_date_time.dart';

class StockModel {
  final String id;
  final String materialId;

  final double currentStock;
  final double reservedStock;
  final double availableStock;

  final DateTime? lastTransactionDate;
  final DateTime? lastUpdated;

  final String materialCode;
  final String materialName;

  final String? materialGroup;
  final String? materialDescription;
  final String? uom;
  final double? minimumStock;

  final String? alertId;
  final String? alertType;
  final String? status;
  final DateTime? generatedAt;

  const StockModel({
    required this.id,
    required this.materialId,
    required this.currentStock,
    required this.reservedStock,
    required this.availableStock,
    this.lastTransactionDate,
    this.lastUpdated,
    required this.materialCode,
    required this.materialName,
    this.materialGroup,
    this.materialDescription,
    this.uom,
    this.minimumStock,
    this.alertId,
    this.alertType,
    this.status,
    this.generatedAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] ?? '',
      materialId: json['materialId'] ?? '',

      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0,

      reservedStock: (json['reservedStock'] as num?)?.toDouble() ?? 0,

      availableStock: (json['availableStock'] as num?)?.toDouble() ?? 0,

      lastTransactionDate: json['lastTransactionDate'] != null
          ? AppDateTime.parseUtcToIst(json['lastTransactionDate'])
          : null,

      lastUpdated: json['lastUpdated'] != null
          ? AppDateTime.parseUtcToIst(json['lastUpdated'])
          : null,

      materialCode: json['materialCode'] ?? '',
      materialName: json['materialName'] ?? '',

      materialGroup: json['materialGroup'],
      materialDescription: json['materialDescription'],
      uom: json['uom'],

      minimumStock: (json['minimumStock'] as num?)?.toDouble(),

      alertId: json['alertId'],
      alertType: json['alertType'],
      status: json['status'],

      generatedAt: json['generatedAt'] != null
          ? AppDateTime.parseUtcToIst(json['generatedAt'])
          : null,
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
      'lastUpdated': lastUpdated?.toIso8601String(),
      'materialCode': materialCode,
      'materialName': materialName,
      'materialGroup': materialGroup,
      'materialDescription': materialDescription,
      'uom': uom,
      'minimumStock': minimumStock,
      'alertId': alertId,
      'alertType': alertType,
      'status': status,
      'generatedAt': generatedAt?.toIso8601String(),
    };
  }

  bool get isLowStock => alertType == 'LOW_STOCK';

  bool get isOutOfStock => alertType == 'OUT_OF_STOCK';

  bool get isOpen => status == 'OPEN';

  bool get isClosed => status == 'CLOSED';

  double get stockPercentage {
    if (minimumStock == null || minimumStock == 0) {
      return 100;
    }

    return (availableStock / minimumStock!) * 100;
  }

  double get shortage {
    if (minimumStock == null) {
      return 0;
    }

    return availableStock < minimumStock! ? minimumStock! - availableStock : 0;
  }
}
