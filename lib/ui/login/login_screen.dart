import 'package:dicoding_story/auth/auth_bloc.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/ui/login/login_form_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_cupertino_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar.large(
      largeTitle: Text("Masuk"),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: () async {
          final registered = await context.push<bool>(AppRoute.register);
          if (registered == true && context.mounted) {
            context.push(AppRoute.registerSuccessDialog);
          }
        },
        child: Text("Daftar"),
      ),
    ),
    child: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          context.push(AppRoute.errorDialog, extra: state.message);
        }
      },
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        builder: (context, state) {
          final formBloc = context.read<LoginFormBloc>();
          final authBloc = context.read<AuthBloc>();

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _LoginContent(formBloc, state, authBloc),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _LoginContent(
    LoginFormBloc formBloc,
    LoginFormState state,
    AuthBloc authBloc,
  ) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 8,
    children: [
      CustomCupertinoTextField(
        placeholder: "E-mail",
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (text) {
          formBloc.add(LoginFormEvent.emailChanged(text));
        },
        errorText: state.emailErrorMessage,
      ),
      CustomCupertinoTextField(
        placeholder: "Password",
        textInputAction: TextInputAction.done,
        obscureText: true,
        onChanged: (text) {
          formBloc.add(LoginFormEvent.passwordChanged(text));
        },
        errorText: state.passwordErrorMessage,
      ),
      AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child:
            authBloc.state is AuthLoading
                ? CupertinoActivityIndicator()
                : Container(
                  margin: EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed:
                          state.canSubmit
                              ? () {
                                authBloc.add(
                                  AuthEvent.login(state.email, state.password),
                                );
                              }
                              : null,
                      child: Text("Masuk"),
                    ),
                  ),
                ),
      ),
    ],
  );
}
