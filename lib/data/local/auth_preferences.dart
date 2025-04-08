import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthPreferences {
  final SharedPreferencesAsync _pref;

  AuthPreferences(this._pref);

  Future<bool> get isLoggedIn async => await _pref.getString(KEY_TOKEN) != null;

  Future<void> setToken(String token) async {
    await _pref.setString(KEY_TOKEN, token);
  }

  Future<String> getToken() async {
    return await _pref.getString(KEY_TOKEN) ?? "";
  }

  Future<void> removeToken() async{
    await _pref.remove(KEY_TOKEN);
  }

  static const KEY_TOKEN = "token";
}
