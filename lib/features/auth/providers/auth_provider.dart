import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;

  const AuthState({this.user, this.isLoading = false});

  AuthState copyWith({UserModel? user, bool? isLoading}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final _repo = AuthRepository();

  @override
  AuthState build() => const AuthState();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final result = await _repo.login(email: email, password: password);
      if (result == null) return false;

      await TokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      api.setToken(result.accessToken);
      state = AuthState(user: result.user);

      return true;
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> tryRestoreSession() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) return false;

    api.setToken(token);

    final user = await _repo.fetchMe();
    if (user == null) {
      await TokenStorage.clear();
      api.setToken(null);
      return false;
    }

    state = AuthState(user: user);
    return true;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _repo.logout(refreshToken);
      } catch (_) {}
    }
    await TokenStorage.clear();
    api.setToken(null);
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
