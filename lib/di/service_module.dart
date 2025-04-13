import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/base_url.dart';
import '../data/local/auth_preferences.dart';

@module
abstract class ServiceModule {
  @singleton
  SharedPreferencesAsync sharedPreferencesAsync() => SharedPreferencesAsync();

  @Named("guest")
  @singleton
  Dio guestDio() => Dio(
    BaseOptions(
      baseUrl: Constants.BASE_URL,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  @Named("user")
  @singleton
  Dio userDio(SharedPreferencesAsync sharedPref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Constants.BASE_URL,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await sharedPref.getString(AuthPreferences.KEY_TOKEN);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}
