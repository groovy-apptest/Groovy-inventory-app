class TransactionModel {
  final String id;
  final String transactionNo;
  final String materialCode;
  final String materialName;
  final String uom;
  final String transactionType;
  final double quantity;
  final double balanceAfter;
  final DateTime transactionDate;
  final String createdByName;

  const TransactionModel({
    required this.id,
    required this.transactionNo,
    required this.materialCode,
    required this.materialName,
    required this.uom,
    required this.transactionType,
    required this.quantity,
    required this.balanceAfter,
    required this.transactionDate,
    required this.createdByName,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      transactionNo: json['transactionNo'] ?? '',
      materialCode: json['materialCode'] ?? '',
      materialName: json['materialName'] ?? '',
      uom: json['uom'] ?? '',
      transactionType: json['transactionType'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble() ?? 0,
      transactionDate: DateTime.parse(json['transactionDate']),
      createdByName: json['createdByName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionNo': transactionNo,
      'materialCode': materialCode,
      'materialName': materialName,
      'uom': uom,
      'transactionType': transactionType,
      'quantity': quantity,
      'balanceAfter': balanceAfter,
      'transactionDate': transactionDate.toIso8601String(),
      'createdByName': createdByName,
    };
  }
}