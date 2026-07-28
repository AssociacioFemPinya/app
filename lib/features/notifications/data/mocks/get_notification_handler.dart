import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/notification_mock.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/notifications_service.dart';

class GetNotificationHandler {
  static void handle(
    NotificationsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // final notificationId = options.path.split('/')[2];
    // final index = notificationsMock.indexWhere((n) => n.id == notificationId);
    handler.resolve(Response(
      requestOptions: options,
      statusCode: 200,
      data: jsonEncode(notificationsMock[0].toJson()),
    ));
  }
}