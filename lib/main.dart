import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/navigation/dialog_page.dart';
import 'package:dicoding_story/navigation/modal_popup_page.dart';
import 'package:dicoding_story/ui/create/create_story_bloc.dart';
import 'package:dicoding_story/ui/create/create_story_screen.dart';
import 'package:dicoding_story/ui/create/maps/choose_location_bloc.dart';
import 'package:dicoding_story/ui/create/maps/choose_location_screen.dart';
import 'package:dicoding_story/ui/details/details_bloc.dart';
import 'package:dicoding_story/ui/details/details_screen.dart';
import 'package:dicoding_story/ui/details/maps/details_maps_screen.dart';
import 'package:dicoding_story/ui/home/home_screen.dart';
import 'package:dicoding_story/ui/home/story_list_bloc.dart';
import 'package:dicoding_story/ui/login/login_form_bloc.dart';
import 'package:dicoding_story/ui/login/login_screen.dart';
import 'package:dicoding_story/ui/register/register_form_bloc.dart';
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
                  builder:
                      (_, _) => BlocProvider(
                        create: (_) => getIt.get<LoginFormBloc>(),
                        child: LoginScreen(),
                      ),
                ),
                GoRoute(
                  path: AppRoute.register,
                  builder:
                      (_, _) => BlocProvider(
                        create: (_) => getIt.get<RegisterFormBloc>(),
                        child: RegisterScreen(),
                      ),
                ),
                GoRoute(
                  path: AppRoute.home,
                  builder:
                      (_, _) => BlocProvider(
                        create:
                            (_) =>
                                getIt<StoryListBloc>()
                                  ..add(StoryListEvent.fetchList()),
                        child: HomeScreen(),
                      ),
                ),
                GoRoute(
                  path: AppRoute.details,
                  builder: (_, state) {
                    final id = state.extra?.toString() ?? "";
                    return BlocProvider(
                      create:
                          (_) =>
                              getIt<DetailsBloc>()
                                ..add(DetailsEvent.fetchDetails(id)),
                      child: DetailsScreen(storyId: id),
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.detailsMap,
                  builder: (_, state) {
                    final latitude =
                        double.tryParse(
                          state.uri.queryParameters[AppRoute.mapLatitude] ?? "",
                        ) ??
                        .0;
                    final longitude =
                        double.tryParse(
                          state.uri.queryParameters[AppRoute.mapLongitude] ??
                              "",
                        ) ??
                        .0;
                    final address =
                        state.uri.queryParameters[AppRoute.mapAddress] ?? "";
                    return DetailsMapsScreen(
                      latitude: latitude,
                      longitude: longitude,
                      address: address,
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.createStory,
                  builder:
                      (_, _) => BlocProvider(
                        create: (_) => getIt<CreateStoryBloc>(),
                        child: CreateStoryScreen(),
                      ),
                ),
                GoRoute(
                  path: AppRoute.createStoryMap,
                  builder: (_, state) {
                    final latitude = double.tryParse(
                      state.uri.queryParameters[AppRoute.mapLatitude] ?? "",
                    );
                    final longitude = double.tryParse(
                      state.uri.queryParameters[AppRoute.mapLongitude] ?? "",
                    );
                    return BlocProvider(
                      create: (_) => getIt<ChooseLocationBloc>(),
                      child: ChooseLocationScreen(
                        latitude: latitude,
                        longitude: longitude,
                      ),
                    );
                  },
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
                  pageBuilder:
                      (context, state) =>
                          CustomDialogPage(child: _SuccessRegister(context)),
                ),
              ],
            ),
          ),
    );
  }

  CupertinoAlertDialog _SuccessRegister(BuildContext context) =>
      CupertinoAlertDialog(
        title: Text("Sukses Membuat Akun!"),
        content: Text("Silahkan masuk menggunakan akun Anda"),
        actions: [
          CupertinoButton(child: Text("Oke"), onPressed: () => context.pop()),
        ],
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
