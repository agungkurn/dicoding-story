part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;

  const factory AuthState.authenticated(String token) = AuthAuthenticated;

  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  const factory AuthState.loginAfterRegister() = AuthLoginAfterRegister;

  const factory AuthState.error(Exception? exception) = AuthError;

  const factory AuthState.loading() = AuthLoading;
}
