import 'package:groovy_inventory/core/utils/app_date_time.dart';

class TransactionHistoryModel {
  final String id;
  final String transactionNo;
  final String materialId;
  final String materialCode;
  final String materialName;
  final String materialGroup;
  final String uom;
  final String transactionType;
  final double quantity;
  final double balanceBefore;
  final double balanceAfter;
  final String referenceNo;
  final String remarks;
  final DateTime transactionDate;
  final String? createdBy;
  final String? createdByName;

  const TransactionHistoryModel({
    required this.id,
    required this.transactionNo,
    required this.materialId,
    required this.materialCode,
    required this.materialName,
    required this.materialGroup,
    required this.uom,
    required this.transactionType,
    required this.quantity,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.referenceNo,
    required this.remarks,
    required this.transactionDate,
    required this.createdBy,
    required this.createdByName,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryModel(
      id: json['id'] ?? '',
      transactionNo: json['transactionNo'] ?? '',
      materialId: json['materialId'] ?? '',
      materialCode: json['materialCode'] ?? '',
      materialName: json['materialName'] ?? '',
      materialGroup: json['materialGroup'] ?? '',
      uom: json['uom'] ?? '',
      transactionType: json['transactionType'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      balanceBefore: (json['balanceBefore'] as num?)?.toDouble() ?? 0,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble() ?? 0,
      referenceNo: json['referenceNo'] ?? '',
      remarks: json['remarks'] ?? '',
      transactionDate: AppDateTime.parseUtcToIst(json['transactionDate']),
      createdBy: json['createdBy'],
      createdByName: json['createdByName'],
    );
  }

  bool get isPositive =>
      transactionType == 'RECEIPT' ||
      transactionType == 'ADJUSTMENT_IN' ||
      transactionType == 'OPENING';
}
