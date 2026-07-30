import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:femcastells/features/user_profile/user_profile.dart';

final sl = GetIt.instance;

Future<void> setupUserProfileServiceLocator(bool useMockApi) async {
  // Important: Keep dio instance on top, otherwise services (which use dio) will get a get_it not found error
  sl.registerSingleton<UserProfileService>(UserProfileServiceImpl());
  sl.registerSingleton<UserProfileRepository>(UserProfileRepositoryImpl());
  sl.registerSingleton<GetUserProfile>(GetUserProfile());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(UserProfileDioMockInterceptor());
  }
}
