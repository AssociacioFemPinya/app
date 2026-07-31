import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fempinya3_flutter_app/features/events/data/mocks/events_service/get_event_handler.dart';
import 'package:fempinya3_flutter_app/features/events/data/mocks/events_service/get_events_list_handler.dart';
import 'package:fempinya3_flutter_app/features/events/data/mocks/events_service/post_event_handler.dart';
import 'package:fempinya3_flutter_app/features/events/data/sources/events_api_endpoints.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/tag.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';

class EventsDioMockInterceptor extends Interceptor {
  late List<EventEntity> eventList;

  int percentageOfRandomFailures = 0;
  int maxDurationRequest = 200;

  Map<
      _MockRouteKey,
      void Function(EventsDioMockInterceptor mock, RequestOptions options,
          RequestInterceptorHandler handler)> mockRouter = {
    _MockRouteKey(EventsApiEndpoints.getEvents, 'GET'):
        GetEventsListHandler.handle,
    _MockRouteKey(EventsApiEndpoints.getEvents, 'GET'): GetEventHandler.handle,
    _MockRouteKey('/event', 'POST'): PostEventHandler.handle,
  };

  EventsDioMockInterceptor() {
    eventList = _generateEvents();
  }

  List<EventEntity> _generateEvents() {
    final random = Random();
    final now = DateTime.now();
    final oneWeekLater = now.add(const Duration(days: 7));

    DateTime getRandomDateTime() {
      final differenceInMillis =
          oneWeekLater.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
      final randomMillis = random.nextInt(differenceInMillis);
      return now.add(Duration(milliseconds: randomMillis));
    }

    List<TagEntity>? generateTags() {
      return [
        const TagEntity(id: 1, name: 'Vegano', isEnabled: true),
        const TagEntity(id: 2, name: 'Arribarè tard', isEnabled: true),
        const TagEntity(id: 3, name: 'Celiac', isEnabled: true),
        const TagEntity(id: 4, name: 'Vinc amb cotxe', isEnabled: true),
        const TagEntity(id: 5, name: 'Necessito cotxe', isEnabled: true),
      ];
    }

    return List<EventEntity>.generate(20, (index) {
      return EventEntity(
          id: index,
          status: EventStatusEnum
              .values[random.nextInt(EventStatusEnum.values.length)],
          title: "EventMockup $index",
          address: "Address $index",
          type:
              EventTypeEnum.values[random.nextInt(EventTypeEnum.values.length)],
          startDate: getRandomDateTime(),
          endDate: DateTime.parse('2024-07-01 02:00:00.000Z'),
          dateHour: '10:00 AM',
          tags: generateTags(),
          companions: 0,
          allowsCompanions: true,
          description:
              'Lorem ipsum dolor sit amet. Sed quisquam minus aut voluptas quibusdam in quia assumenda non consequatur voluptates in consequatur omnis. Qui praesentium officia aut neque neque qui omnis eligendi et eaque ducimus sit molestias harum. A obcaecati labore aut nobis ullam aut sint dolorem.');
    });
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Sleep between 0 and 1 seconds to simulate a slow API
    final random = Random();
    final randomDuration =
        Duration(milliseconds: random.nextInt(maxDurationRequest));
    await Future.delayed(randomDuration);

    // Check the request path and method and provide a mock response
    final routeKey = _MockRouteKey(options.path, options.method);
    if (mockRouter.containsKey(routeKey)) {
      final random = Random();
      if (random.nextInt(101) > 100 - percentageOfRandomFailures) {
        handler.resolve(Response(
          requestOptions: options,
          statusCode: 500,
        ));
      } else {
        mockRouter[routeKey]!(this, options, handler);
        // Close easyLoading as seems that resolve the query in the mock doesn't follow the interceptor chain
        EasyLoading.dismiss();
      }
    } else {
      // Forward the request if not mocking
      handler.next(options);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Handle errors if needed
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle responses if needed
    super.onResponse(response, handler);
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
