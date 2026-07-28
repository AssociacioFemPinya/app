import 'package:dartz/dartz.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/sources/notifications_service.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/service_locator.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Future<Either> getNotifications(GetNotificationsParams params) async {
      return await sl<NotificationsService>().getNotifications(params);
  }
  @override
  Future<Either> getNotification(GetNotificationParams params) async {
    return await sl<NotificationsService>().getNotification(params);
  }
  @override
  Future<Either> updateReadStatus(String notificationId) async {
      return await sl<NotificationsService>().updateReadStatus(notificationId);
  }
} 