import 'package:fempinya3_flutter_app/features/events/service_locator.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/entities/notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_view_events.dart';
part 'notifications_view_state.dart';

class NotificationViewBloc extends Bloc<NotificationViewEvent, NotificationViewState> {
  NotificationViewBloc() : super(NotificationViewInitial(notification: null)) {
    on<LoadNotification>((notificationID, emit) async {
      GetNotificationParams getNotificationParams = GetNotificationParams(id: notificationID.value);
      var result = await sl<GetNotification>().call(params: getNotificationParams);

      result.fold((failure) {
        add(NotificationLoadFailure(failure));
      }, (data) {
        add(NotificationLoadSuccess(data));
      });
    });

    on<NotificationLoadSuccess>((notification, emit) {
      emit(NotificationViewEventLoaded(notification: notification.value));
    });

    on<NotificationLoadFailure>((errorMessage, emit) {
      // TODO
    });
  }
}
