part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkRequested() = _CheckRequested;

  const factory AuthEvent.login(String email, String password) = _Login;

  const factory AuthEvent.register(String name, String email, String password) =
      _Register;

  const factory AuthEvent.logout() = _Logout;
}
