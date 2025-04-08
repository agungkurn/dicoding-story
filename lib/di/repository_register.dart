import 'package:dicoding_story/data/remote/story_api.dart';
import 'package:dicoding_story/data/repository/story_repository.dart';

import '../data/local/auth_preferences.dart';
import '../data/remote/auth_api.dart';
import '../data/repository/auth_repository.dart';
import 'di_config.dart';

void registerRepository() {
  getIt.registerLazySingletonAsync<AuthRepository>(() async {
    final authApi = await getIt.getAsync<AuthApi>();
    final authPreferences = await getIt.getAsync<AuthPreferences>();
    return AuthRepository(authApi, authPreferences);
  });
  getIt.registerLazySingletonAsync<StoryRepository>(() async {
    final storyApi = await getIt.getAsync<StoryApi>();
    return StoryRepository(storyApi);
  });
}
