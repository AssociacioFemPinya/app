part of 'notifications_view_bloc.dart';

abstract class NotificationViewEvent {}

class LoadNotification extends NotificationViewEvent {
  final int value;
  LoadNotification(this.value);
}

class NotificationLoadSuccess extends NotificationViewEvent {
  final NotificationEntity value;
  NotificationLoadSuccess(this.value);
}

class NotificationLoadFailure extends NotificationViewEvent {
  final String value;
  NotificationLoadFailure(this.value);
}
