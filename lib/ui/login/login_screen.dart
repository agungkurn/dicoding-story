import 'package:dicoding_story/auth/auth_bloc.dart';
import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/ui/login/login_form_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_cupertino_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => getIt.get<LoginFormBloc>(),
    child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text("Masuk"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: () async {
            final registered = await context.push<bool>(AppRoute.register);
            if (registered == true) {
              showCupertinoDialog(
                context: context,
                builder:
                    (context) => CupertinoAlertDialog(
                      title: Text("Sukses Membuat Akun!"),
                      content: Text("Silahkan masuk menggunakan akun Anda"),
                      actions: [
                        CupertinoButton(
                          child: Text("Oke"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            }
          },
          child: Text("Daftar"),
        ),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showCupertinoDialog(
              context: context,
              builder:
                  (context) => CupertinoAlertDialog(
                    title: Text("Terjadi kesalahan"),
                    content: Text(state.message ?? "Silahkan coba lagi nanti"),
                    actions: [
                      CupertinoButton(
                        child: Text("Oke"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
            );
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
                  child: Column(
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
                                                  AuthEvent.login(
                                                    state.email,
                                                    state.password,
                                                  ),
                                                );
                                              }
                                              : null,
                                      child: Text("Masuk"),
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
