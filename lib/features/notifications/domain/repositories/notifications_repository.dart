import 'package:dartz/dartz.dart';
import 'package:femcastells/features/notifications/domain/useCases/get_notifications.dart';

abstract class NotificationsRepository {
  Future<Either> getNotifications(GetNotificationsParams params);
  Future<Either> updateReadStatus(String notificationId);
}
