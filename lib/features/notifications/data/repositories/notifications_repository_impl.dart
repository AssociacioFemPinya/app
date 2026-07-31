import 'package:dartz/dartz.dart';
import 'package:femcastells/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:femcastells/features/notifications/data/sources/notifications_service.dart';
import 'package:femcastells/features/notifications/service_locator.dart';
import 'package:femcastells/features/notifications/domain/useCases/get_notifications.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Future<Either> getNotifications(GetNotificationsParams params) async {
      return await sl<NotificationsService>().getNotifications(params);
  }

  @override
  Future<Either> updateReadStatus(String notificationId) async {
      return await sl<NotificationsService>().updateReadStatus(notificationId);
  }
} 