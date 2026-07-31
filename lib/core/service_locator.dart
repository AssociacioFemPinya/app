import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:femcastells/core/network/dio_factory.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Logger createLogger() {
  return Logger(
    level: Level.debug, // Cambia el nivel según sea necesario
    printer: PrettyPrinter(),
  );
}

Future<void> setupCommonServiceLocator() async {
  // Important: Keep dio instance on top, otherwise services (which use dio) will get a get_it not found error
  sl.registerLazySingleton<Dio>(() => DioFactory.getInstance());
  sl.registerLazySingleton<Logger>(() => createLogger());
}
