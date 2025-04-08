part of 'register_form_bloc.dart';

@freezed
abstract class RegisterFormEvent with _$RegisterFormEvent {
  const factory RegisterFormEvent.nameChanged(String data) = _NameChanged;

  const factory RegisterFormEvent.emailChanged(String data) = _EmailChanged;

  const factory RegisterFormEvent.passwordChanged(String data) = _PasswordChanged;
}
