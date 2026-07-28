import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/entities/notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/update_read_status.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final getNotifications = GetIt.instance<GetNotifications>();
  final updateReadStatus = GetIt.instance<UpdateReadStatus>();

  NotificationsBloc() : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<UpdateReadStatusEvent>(_onUpdateReadStatus);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) {
      emit(NotificationsLoading());
    }
    try {
      final result = await getNotifications(params: GetNotificationsParams());
      result.fold(
        (failure) {
          emit(NotificationsError(failure.toString()));
        },
        (notifications) {
          emit(NotificationsLoaded(notifications));
        },
      );
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onUpdateReadStatus(
    UpdateReadStatusEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await updateReadStatus(notificationId: event.notificationId);
    result.fold(
      (failure) => emit(NotificationsError(failure.toString())),
      (_) => add(LoadNotifications()),
    );
  }
} 