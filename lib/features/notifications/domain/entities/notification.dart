import 'package:equatable/equatable.dart';
import 'package:femcastells/features/notifications/data/models/notification_model.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, message, createdAt, isRead];

  factory NotificationEntity.fromModel(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      title: model.title,
      message: model.message,
      createdAt: model.createdAt,
      isRead: model.isRead,
    );
  }

  NotificationModel toModel() {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
} 