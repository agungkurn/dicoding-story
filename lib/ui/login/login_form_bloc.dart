import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'login_form_bloc.freezed.dart';

part 'login_form_event.dart';

part 'login_form_state.dart';

@injectable
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc() : super(LoginFormState.initial()) {
    on<_EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.data,
          emailErrorMessage:
              event.data.contains("@") ? null : "Format e-mail tidak valid",
        ),
      );
    });
    on<_PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.data,
          passwordErrorMessage:
              event.data.trim().length >= 8
                  ? null
                  : "Password minimal 8 karakter",
        ),
      );
    });
  }
}
