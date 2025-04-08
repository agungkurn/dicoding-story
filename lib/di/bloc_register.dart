import '../auth/auth_bloc.dart';
import '../data/repository/auth_repository.dart';
import 'di_config.dart';

void registerBloc() {
  getIt.registerLazySingletonAsync<AuthBloc>(() async {
    final repository = await getIt.getAsync<AuthRepository>();
    return AuthBloc(repository);
  });
}
