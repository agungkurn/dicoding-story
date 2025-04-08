import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/navigation/app_route.dart';
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
    final authBloc = context.watch<AuthBloc>();

    return CupertinoApp.router(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(),
      routerConfig: GoRouter(
        redirect: (context, state) {
          switch (authBloc.state) {
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
        ],
      ),
    );
  }
}
