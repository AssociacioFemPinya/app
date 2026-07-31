import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:femcastells/features/notifications/data/mocks/notification_mock.dart';
import 'package:femcastells/features/notifications/data/mocks/notifications_service.dart';

class GetNotificationsHandler {
  static void handle(
    NotificationsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.resolve(Response(
      requestOptions: options,
      statusCode: 200,
      data: jsonEncode(notificationsMock.map((n) => n.toJson()).toList()),
    ));
  }
} 