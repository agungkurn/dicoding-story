import 'package:dicoding_story/auth/auth_bloc.dart';
import 'package:dicoding_story/ui/register/register_form_bloc.dart';
import 'package:dicoding_story/widgets/custom_cupertino_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_route.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar.large(
      largeTitle: Text("Daftar"),
      previousPageTitle: "Masuk",
    ),
    child: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          context.push(AppRoute.errorDialog, extra: state.message);
        } else if (state is AuthLoginAfterRegister) {
          context.pop(true);
        }
      },
      child: BlocBuilder<RegisterFormBloc, RegisterFormState>(
        builder: (context, state) {
          final formBloc = context.read<RegisterFormBloc>();
          final authBloc = context.read<AuthBloc>();

          return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _RegisterContent(formBloc, state, authBloc),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget _RegisterContent(RegisterFormBloc formBloc,
      RegisterFormState state,
      AuthBloc authBloc,) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          CustomCupertinoTextField(
            placeholder: "Nama",
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onChanged: (text) {
              formBloc.add(RegisterFormEvent.nameChanged(text));
            },
            errorText: state.nameErrorMessage,
          ),
          CustomCupertinoTextField(
            placeholder: "E-mail",
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              formBloc.add(RegisterFormEvent.emailChanged(text));
            },
            errorText: state.emailErrorMessage,
          ),
          CustomCupertinoTextField(
            placeholder: "Password",
            textInputAction: TextInputAction.done,
            obscureText: true,
            onChanged: (text) {
              formBloc.add(RegisterFormEvent.passwordChanged(text));
            },
            errorText: state.passwordErrorMessage,
          ),
          authBloc.state == AuthLoading()
              ? CupertinoActivityIndicator()
              : Container(
            margin: EdgeInsets.only(top: 8),
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed:
              state.canSubmit
                  ? () {
                authBloc.add(
                  AuthEvent.register(
                    state.name,
                    state.email,
                    state.password,
                  ),
                );
              }
                  : null,
              child: Text("Daftar"),
            ),
          ),
        ],
  );
}
