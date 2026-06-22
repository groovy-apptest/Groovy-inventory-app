class UserModel {
  final String id;
  final String employeeCode;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.employeeCode,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      employeeCode: json['employeeCode'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      isActive: json['isActive'],
    );
  }
}