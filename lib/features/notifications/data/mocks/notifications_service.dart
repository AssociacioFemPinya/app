import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/get_notification_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fempinya3_flutter_app/features/notifications/data/mocks/get_notifications_handler.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/mocks/update_read_status_handler.dart';
import 'package:fempinya3_flutter_app/global_endpoints.dart';
import 'package:fempinya3_flutter_app/features/notifications/data/sources/notifications_api_endpoints.dart';

class NotificationsDioMockInterceptor extends Interceptor {
  int percentageOfRandomFailures = 0;
  int maxDurationRequest = 200;

  Map<_MockRouteKey, void Function(NotificationsDioMockInterceptor mock,
          RequestOptions options, RequestInterceptorHandler handler)>
      mockRouter = {
    _MockRouteKey(NotificationsApiEndpoints.getNotifications, 'GET'):
        GetNotificationsHandler.handle,
    // _MockRouteKey(buildEndpoint(NotificationsApiEndpoints.updateReadNotification,
    //         {'notificationId': ':id'}),
    //     'GET'): GetNotificationHandler.handle,
    _MockRouteKey("/notifications/1", 'GET'): GetNotificationHandler.handle,
    _MockRouteKey(
        buildEndpoint(NotificationsApiEndpoints.updateReadNotification,
            {'notificationId': ':id'}),
        'PATCH'): UpdateReadStatusHandler.handle,
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final random = Random();
    final randomDuration = Duration(milliseconds: random.nextInt(maxDurationRequest));
    await Future.delayed(randomDuration);

    final routeKey = _processRouteKey(options);
    
    if (mockRouter.containsKey(routeKey)) {
      if (random.nextInt(101) > 100 - percentageOfRandomFailures) {
        handler.resolve(Response(
          requestOptions: options,
          statusCode: 500,
        ));
      } else {
        mockRouter[routeKey]!(this, options, handler);
        EasyLoading.dismiss();
      }
    } else {
      handler.next(options);
    }
  }

  _MockRouteKey _processRouteKey(RequestOptions options) {
    final path = options.path;
    if (options.method == 'PATCH' && path.contains('/notifications/') && path.endsWith('/read')) {
      return _MockRouteKey('/notifications/:id/read', 'PATCH');
    }
    return _MockRouteKey(path, options.method);
  }
}

class _MockRouteKey {
  final String path;
  final String method;

  _MockRouteKey(this.path, this.method);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MockRouteKey &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          method == other.method;

  @override
  int get hashCode => path.hashCode ^ method.hashCode;
}
