import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/notification_mock.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/notifications_service.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/models/notification_model.dart';

class UpdateReadStatusHandler {
  static void handle(
    NotificationsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final notificationId = options.path.split('/')[2];
    final index = notificationsMock.indexWhere((n) => n.id == notificationId);
    
    if (index != -1) {
      notificationsMock[index] = NotificationModel(
        id: notificationsMock[index].id,
        title: notificationsMock[index].title,
        message: notificationsMock[index].message,
        createdAt: notificationsMock[index].createdAt,
        sender: notificationsMock[index].sender,
        isRead: true,
      );
    }

    handler.resolve(Response(
      requestOptions: options,
      statusCode: 200,
    ));
  }
} 