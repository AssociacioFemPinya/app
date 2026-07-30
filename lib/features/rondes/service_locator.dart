import 'package:dio/dio.dart';
import 'package:femcastells/features/rondes/rondes.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupRondesServiceLocator(bool useMockApi) async {
  // Important: Keep dio instance on top, otherwise services (which use dio) will get a get_it not found error
  sl.registerSingleton<RondesService>(RondesServiceImpl());
  sl.registerSingleton<RondesRepository>(RondesRepositoryImpl());
  sl.registerSingleton<GetRondesList>(GetRondesList());
  sl.registerSingleton<GetRonda>(GetRonda());
  sl.registerSingleton<GetPublicDisplayUrl>(GetPublicDisplayUrl());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(RondesDioMockInterceptor());
  }
}
