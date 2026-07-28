import 'package:dartz/dartz.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';

abstract class NotificationsRepository {
  Future<Either> getNotifications(GetNotificationsParams params);
  Future<Either> getNotification(GetNotificationParams params);
  Future<Either> updateReadStatus(String notificationId);
}
