part of 'login_form_bloc.dart';

@freezed
abstract class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    required String email,
    required String? emailErrorMessage,
    required String password,
    required String? passwordErrorMessage,
  }) = _LoginFormState;

  factory LoginFormState.initial() => const LoginFormState(
    email: "",
    emailErrorMessage: null,
    password: "",
    passwordErrorMessage: null,
  );
}

extension LoginFormStateExtension on LoginFormState {
  bool get canSubmit =>
      email.trim().isNotEmpty &&
      emailErrorMessage == null &&
      password.trim().isNotEmpty &&
      passwordErrorMessage == null;
}
