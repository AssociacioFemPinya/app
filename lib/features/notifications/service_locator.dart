import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/notifications_service.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notification.dart';
import 'package:get_it/get_it.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/sources/notifications_service.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/update_read_status.dart';

final sl = GetIt.instance;


Future<void> setupNotificationsServiceLocator(bool useMockApi) async {
  // Important: Keep dio instance on top, otherwise services (which use dio) will get a get_it not found error
  sl.registerSingleton<NotificationsService>(NotificationsServiceImpl());
  sl.registerSingleton<NotificationsRepository>(NotificationsRepositoryImpl());
  sl.registerSingleton<GetNotifications>(GetNotifications());
  sl.registerSingleton<GetNotification>(GetNotification());
  sl.registerSingleton<UpdateReadStatus>(UpdateReadStatus());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(NotificationsDioMockInterceptor());
  }
}