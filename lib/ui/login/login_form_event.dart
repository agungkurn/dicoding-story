part of 'login_form_bloc.dart';

@freezed
sealed class LoginFormEvent with _$LoginFormEvent {
  const factory LoginFormEvent.emailChanged(String data) = _EmailChanged;

  const factory LoginFormEvent.passwordChanged(String data) = _PasswordChanged;
}
