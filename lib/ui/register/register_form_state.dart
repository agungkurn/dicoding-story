part of 'register_form_bloc.dart';

@freezed
abstract class RegisterFormState with _$RegisterFormState {
  const factory RegisterFormState({
    required String name,
    required String? nameErrorMessage,
    required String email,
    required String? emailErrorMessage,
    required String password,
    required String? passwordErrorMessage,
  }) = _RegisterFormState;

  factory RegisterFormState.initial() => const RegisterFormState(
    name: "",
    nameErrorMessage: null,
    email: "",
    emailErrorMessage: null,
    password: "",
    passwordErrorMessage: null,
  );
}

extension RegisterFormStateExtension on RegisterFormState {
  bool get canSubmit =>
      name.trim().isNotEmpty &&
      nameErrorMessage == null &&
      email.trim().isNotEmpty &&
      emailErrorMessage == null &&
      password.trim().isNotEmpty &&
      passwordErrorMessage == null;
}
