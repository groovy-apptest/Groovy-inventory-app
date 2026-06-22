import '../models/login_response.dart';
import '../models/user_model.dart';
import '../../../core/network/api_client.dart';

class AuthRepository {
  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    final response = await api.post<LoginResponse>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      fromData: (json) => LoginResponse.fromJson(json),
    );

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data;
  }

  Future<UserModel?> fetchMe() async {
    final response = await api.get<UserModel>(
      '/auth/me',
      fromData: (json) => UserModel.fromJson(json),
    );

    if (!response.success) return null;

    return response.data;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await api.post(
      '/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (!response.success) {
      throw Exception(response.message);
    }
  }

  Future<void> logout(String refreshToken) async {
    await api.post(
      '/auth/logout',
      data: {'refreshToken': refreshToken},
    );
  }
}