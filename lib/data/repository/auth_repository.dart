import 'package:dicoding_story/data/local/auth_preferences.dart';
import 'package:dicoding_story/data/remote/auth_api.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepository {
  final AuthApi _api;
  final AuthPreferences _pref;

  AuthRepository(this._api, this._pref);

  Future<void> register(String name, String email, String password) async {
    try {
      await _api.register(name, email, password);
    } catch (e, stack) {
      if (kDebugMode) print(stack);
      rethrow;
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final result = await _api.login(email, password);
      return result.loginResult.token;
    } catch (e, stack) {
      if (kDebugMode) print(stack);
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    return await _pref.isLoggedIn;
  }

  Future<void> setToken(String token) async {
    await _pref.setToken(token);
  }

  Future<String> getToken() async {
    return await _pref.getToken();
  }

  Future<void> logout() async {
    await _pref.removeToken();
  }
}
