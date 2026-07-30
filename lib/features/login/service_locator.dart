import 'package:dio/dio.dart';
import 'package:femcastells/features/login/login.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupLoginServiceLocator(bool useMockApi) async {
  sl.registerSingleton<UsersService>(UsersServiceImpl());
  sl.registerSingleton<UsersRepository>(UsersRepositoryImpl());
  sl.registerSingleton<GetUser>(GetUser());
  sl.registerSingleton<GetToken>(GetToken());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(UsersDioMockInterceptor());
    _dio.interceptors.add(TokensDioMockInterceptor());
  }
}
