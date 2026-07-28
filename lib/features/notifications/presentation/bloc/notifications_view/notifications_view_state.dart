part of 'notifications_view_bloc.dart';

class NotificationViewState {
  final NotificationEntity? notification;

  NotificationViewState({required this.notification});

  NotificationViewState copyWith({
    NotificationEntity? event,
  }) {
    return NotificationViewState(
      notification: notification ?? this.notification,
    );
  }
}

class NotificationViewInitial extends NotificationViewState {
  NotificationViewInitial({required super.notification});
}

class NotificationViewEventLoaded extends NotificationViewState {
  NotificationViewEventLoaded({required super.notification});
}

class NotificationViewEventLoadFailure extends NotificationViewState {
  NotificationViewEventLoadFailure({required super.notification});
}
class NotificationViewEventUpdated extends NotificationViewState {
  NotificationViewEventUpdated({required super.notification});
}
class NotificationViewEventUpdateFailure extends NotificationViewState {
  NotificationViewEventUpdateFailure({required super.notification});
}

