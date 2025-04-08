import 'package:dicoding_story/data/remote/story_api.dart';
import 'package:dio/dio.dart';

import '../data/remote/auth_api.dart';
import 'di_config.dart';

void registerRemote() {
  getIt.registerLazySingletonAsync<AuthApi>(() async {
    final dio = await getIt.getAsync<Dio>(instanceName: "guest");
    return AuthApi(dio);
  });
  getIt.registerLazySingletonAsync<StoryApi>(() async {
    final dio = await getIt.getAsync<Dio>(instanceName: "user");
    return StoryApi(dio);
  });
}
