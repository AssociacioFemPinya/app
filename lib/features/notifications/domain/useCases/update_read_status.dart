import 'package:dartz/dartz.dart';
import 'package:femcastells/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:femcastells/features/notifications/service_locator.dart';

class UpdateReadStatus {
  final NotificationsRepository repository = sl<NotificationsRepository>();

  Future<Either> call({required String notificationId}) async {
    return await repository.updateReadStatus(notificationId);
  }
} 