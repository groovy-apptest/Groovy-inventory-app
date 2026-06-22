class MaterialModel {
  final String id;
  final String materialCode;
  final String materialName;
  final String materialGroup;
  final String uom;
  final double minimumStock;
  final bool isActive;

  const MaterialModel({
    required this.id,
    required this.materialCode,
    required this.materialName,
    required this.materialGroup,
    required this.uom,
    required this.minimumStock,
    required this.isActive,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] ?? '',
      materialCode: json['materialCode'] ?? '',
      materialName: json['materialName'] ?? '',
      materialGroup: json['materialGroup'] ?? '',
      uom: json['uom'] ?? '',
      minimumStock: (json['minimumStock'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }
}
