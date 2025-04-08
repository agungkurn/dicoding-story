import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/auth_preferences.dart';
import 'di_config.dart';

void registerLocal() {
  getIt.registerLazySingletonAsync<AuthPreferences>(() async {
    final sharedPref = await getIt.getAsync<SharedPreferencesAsync>();
    return AuthPreferences(sharedPref);
  });
}
