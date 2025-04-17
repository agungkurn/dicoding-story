import 'package:dicoding_story/data/model/request/login_request.dart';
import 'package:dicoding_story/data/model/request/register_request.dart';
import 'package:dicoding_story/data/model/response/login_response.dart';
import 'package:dicoding_story/data/model/response/register_response.dart';
import 'package:dicoding_story/data/remote/display_exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthApi {
  final Dio _dio;

  AuthApi(@Named("guest") this._dio);

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final request = RegisterRequest(
      name: name,
      email: email,
      password: password,
    );

    final response = await _dio.post("/register", data: request.toJson());
    final parsed = RegisterResponse.fromJson(response.data);

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);

    final response = await _dio.post("/login", data: request.toJson());
    final parsed = LoginResponse.fromJson(response.data);

    if (parsed.error) {
      throw DisplayException(parsed.message);
    } else {
      return parsed;
    }
  }
}
