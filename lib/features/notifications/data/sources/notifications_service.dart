import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notification.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:fempinya3_flutter_app/features/notifications/data/models/notification_model.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/entities/notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/service_locator.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/sources/notifications_api_endpoints.dart';
import 'package:fempinya3_flutter_app/global_endpoints.dart';

abstract class NotificationsService {
  Future<Either<String, List<NotificationEntity>>> getNotifications(GetNotificationsParams params);
  Future<Either<String, NotificationEntity>> getNotification(GetNotificationParams params);
  Future<Either<String, void>> updateReadStatus(String notificationId);
}

class NotificationsServiceImpl implements NotificationsService {
  final Dio _dio = sl<Dio>();
  final Logger _logger = sl<Logger>();

  @override
  Future<Either<String, List<NotificationEntity>>> getNotifications(GetNotificationsParams params) async {
    try {
      final response =
          await _dio.get(NotificationsApiEndpoints.getNotifications);
      if (response.statusCode == 200 && response.data is String) {
        final jsonList = jsonDecode(response.data as String) as List<dynamic>;
        final notifications = jsonList
            .map((json) => NotificationEntity.fromModel(NotificationModel.fromJson(json)))
            .toList();
        return Right(notifications);
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling ${NotificationsApiEndpoints.getNotifications} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling ${NotificationsApiEndpoints.getNotifications} endpoint: $e');
    }
  }

 @override
  Future<Either<String, NotificationEntity>> getNotification(GetNotificationParams params) async {
    try {
      final response =
          await _dio.get('${NotificationsApiEndpoints.getNotifications}/${params.id}');
      if (response.statusCode == 200 && response.data is String) {
        final json = jsonDecode(response.data as String) as Map<String, dynamic>;
        return Right(NotificationEntity.fromModel((NotificationModel.fromJson(json))));
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling ${NotificationsApiEndpoints.getNotifications}/${params.id} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling ${NotificationsApiEndpoints.getNotifications}/${params.id} endpoint: $e');
    }
  }

  @override
  Future<Either<String, void>> updateReadStatus(String notificationId) async {
    String endpoint = buildEndpoint(
        NotificationsApiEndpoints.updateReadNotification,
        {'notificationId': notificationId});
    try {
      final response = await _dio.patch(
        endpoint,
      );
      if (response.statusCode == 200) {
        return const Right(null);
      }
      return const Left('Failed to update notification status');
    } catch (e, stacktrace) {
      _logError('Error when calling $endpoint to update notification status', e,
          stacktrace);
      return Left(
          'Error when calling $endpoint to update notification status $e');
    }
  }

  void _logError(String message, dynamic error, StackTrace stacktrace) {
    _logger.e(message, error, stacktrace);
  }
} 