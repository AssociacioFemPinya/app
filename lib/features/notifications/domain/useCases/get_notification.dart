import 'package:dartz/dartz.dart';
import 'package:fempinya3_flutter_app/core/usecase/usecase.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fempinya3_flutter_app/features/notifications/service_locator.dart';

class GetNotificationParams {
  final int? id;

  GetNotificationParams({
    this.id,
  });
}

class GetNotification implements UseCase<Either, GetNotificationParams> {
  final NotificationsRepository repository = sl<NotificationsRepository>();

  @override
  Future<Either> call({required GetNotificationParams params}) async {
    return await repository.getNotification(params);
  }
}
