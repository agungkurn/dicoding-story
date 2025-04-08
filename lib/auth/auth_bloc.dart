import 'package:dicoding_story/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../data/remote/display_exception.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthState.initial()) {
    on<_CheckRequested>((event, emit) async {
      final loggedIn = await _repository.isLoggedIn();
      final token = await _repository.getToken();

      if (loggedIn && token.isNotEmpty) {
        emit(AuthState.authenticated(token));
      } else {
        emit(AuthState.unauthenticated());
      }
    });
    on<_Login>((event, emit) async {
      emit(AuthState.loading());

      try {
        final token = await _repository.login(event.email, event.password);
        await _repository.setToken(token);
        emit(AuthState.authenticated(token));
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(AuthState.error(msg));
      }
    });
    on<_Register>((event, emit) async {
      emit(AuthState.loading());

      try {
        await _repository.register(event.name, event.email, event.password);
        emit(AuthState.loginAfterRegister());
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(AuthState.error(msg));
      }
    });
    on<_Logout>((event, emit) async {
      emit(AuthState.loading());

      try {
        await _repository.logout();
        emit(AuthState.unauthenticated());
      } on Exception catch (e) {
        final msg = (e is DisplayException) ? e.message : null;
        emit(AuthState.error(msg));
      }
    });
  }
}
