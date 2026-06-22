import 'user_model.dart';

class LoginResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}