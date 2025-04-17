import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthPreferences {
  final SharedPreferencesAsync _pref;

  AuthPreferences(this._pref);

  Future<bool> get isLoggedIn async => await _pref.getString(keyToken) != null;

  Future<void> setToken(String token) async {
    await _pref.setString(keyToken, token);
  }

  Future<String> getToken() async {
    return await _pref.getString(keyToken) ?? "";
  }

  Future<void> removeToken() async {
    await _pref.remove(keyToken);
  }

  static const keyToken = "token";
}
