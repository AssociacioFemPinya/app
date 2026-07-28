part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class UpdateReadStatusEvent extends NotificationsEvent {
  final String notificationId;

  const UpdateReadStatusEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
} 