import 'package:dio/dio.dart';
import 'package:femcastells/features/notifications/data/mocks/notifications_service.dart';
import 'package:get_it/get_it.dart';
import 'package:femcastells/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:femcastells/features/notifications/data/sources/notifications_service.dart';
import 'package:femcastells/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:femcastells/features/notifications/domain/useCases/get_notifications.dart';
import 'package:femcastells/features/notifications/domain/useCases/update_read_status.dart';

final sl = GetIt.instance;


Future<void> setupNotificationsServiceLocator(bool useMockApi) async {
  // Important: Keep dio instance on top, otherwise services (which use dio) will get a get_it not found error
  sl.registerSingleton<NotificationsService>(NotificationsServiceImpl());
  sl.registerSingleton<NotificationsRepository>(NotificationsRepositoryImpl());
  sl.registerSingleton<GetNotifications>(GetNotifications());
  sl.registerSingleton<UpdateReadStatus>(UpdateReadStatus());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(NotificationsDioMockInterceptor());
  }
}