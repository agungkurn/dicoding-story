import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/navigation/dialog_page.dart';
import 'package:dicoding_story/navigation/modal_popup_page.dart';
import 'package:dicoding_story/ui/create/create_story_screen.dart';
import 'package:dicoding_story/ui/details/details_screen.dart';
import 'package:dicoding_story/ui/home/home_screen.dart';
import 'package:dicoding_story/ui/login/login_screen.dart';
import 'package:dicoding_story/ui/register/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt.get<AuthBloc>()..add(AuthEvent.checkRequested()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder:
          (_, authBlocState) => CupertinoApp.router(
            title: 'Flutter Demo',
            theme: CupertinoThemeData(),
            routerConfig: GoRouter(
              redirect: (context, state) {
                switch (authBlocState) {
                  case AuthAuthenticated():
                    final isInHome = state.uri.path.contains(AppRoute.home);
                    return isInHome ? null : AppRoute.home;
                  case AuthUnauthenticated():
                    final isInAuth = state.uri.path.contains(AppRoute.auth);
                    return isInAuth ? null : AppRoute.login;
                  default:
                    return null;
                }
              },
              routes: [
                GoRoute(
                  path: AppRoute.login,
                  builder: (context, state) => LoginScreen(),
                ),
                GoRoute(
                  path: AppRoute.register,
                  builder: (context, state) => RegisterScreen(),
                ),
                GoRoute(
                  path: AppRoute.home,
                  builder: (context, state) => HomeScreen(),
                ),
                GoRoute(
                  path: AppRoute.details,
                  builder: (context, state) {
                    final id = state.extra?.toString() ?? "";
                    return DetailsScreen(storyId: id);
                  },
                ),
                GoRoute(
                  path: AppRoute.createStory,
                  builder: (context, state) => CreateStoryScreen(),
                ),
                GoRoute(
                  path: AppRoute.errorDialog,
                  pageBuilder: (context, state) {
                    final message = state.extra?.toString();
                    return CustomDialogPage(
                      child: _ErrorDialog(context, message),
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.sheetHome,
                  pageBuilder:
                      (context, state) =>
                          CustomModalPopupPage(child: _HomeSheet(context)),
                ),
                GoRoute(
                  path: AppRoute.registerSuccessDialog,
                  pageBuilder: (context, state) => _SuccessRegister(context),
                ),
              ],
            ),
          ),
    );
  }

  CustomDialogPage _SuccessRegister(BuildContext context) => CustomDialogPage(
    child: CupertinoAlertDialog(
      title: Text("Sukses Membuat Akun!"),
      content: Text("Silahkan masuk menggunakan akun Anda"),
      actions: [
        CupertinoButton(child: Text("Oke"), onPressed: () => context.pop()),
      ],
    ),
  );

  CupertinoActionSheet _HomeSheet(BuildContext context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        onPressed: () {
          context.pop(0);
        },
        child: Text("Buat Story"),
      ),
      CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          context.pop(1);
        },
        child: Text("Keluar"),
      ),
    ],
  );

  CupertinoAlertDialog _ErrorDialog(BuildContext context, String? message) =>
      CupertinoAlertDialog(
        title: Text("Terjadi kesalahan"),
        content: Text(message ?? "Silahkan coba lagi nanti"),
        actions: [
          CupertinoButton(child: Text("Oke"), onPressed: () => context.pop()),
        ],
      );
}
