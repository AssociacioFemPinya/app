import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/core/utils/datetime_utils.dart';
import 'package:fempinya3_flutter_app/features/events/data/mocks/events_service/events_service.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';

abstract class GetEventsListHandler {
  static void handle(
    EventsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final queryParams = options.queryParameters;
    List<String> eventTypeFilters = queryParams["eventTypeFilters"] ?? [];

    DateTimeRange? dayTimeRange;
    if (queryParams['startDate'] != null) {
      dayTimeRange = DateTimeRange.generateDateTimeRangeForDay(
          DateTime.parse(queryParams['startDate']));
    } else {
      dayTimeRange = null;
    }

    final List<EventEntity> events = _filterEvents(
        mock,
        eventTypeFilters
            .map((eventTypeFilter) =>
                EventTypeEnumExtension.fromString(eventTypeFilter))
            .toList(),
        dayTimeRange,
        queryParams["showAnswered"],
        queryParams["showUndefined"]);

    Response<dynamic> response;

    // Create a response object
    response = Response(
      requestOptions: options,
      data:
          jsonEncode(events.map((event) => event.toModel().toJson()).toList()),
      statusCode: 200,
    );

    // Complete the request with the mock response
    handler.resolve(response);
  }

  static List<EventEntity> _filterEvents(
    EventsDioMockInterceptor mock,
    List<EventTypeEnum> eventTypeFilters,
    final DateTimeRange? dayTimeRange,
    bool showAnswered,
    bool showUndefined,
  ) {
    List<EventEntity> events = dayTimeRange != null
        ? _getEventsByDateRange(dayTimeRange, mock.eventList)
        : mock.eventList;

    List<EventEntity> filteredEventsByType =
        _filterByType(events, eventTypeFilters);
    return _filterByStatus(filteredEventsByType, showAnswered, showUndefined);
  }

  static List<EventEntity> _filterByType(
    List<EventEntity> eventsList,
    List<EventTypeEnum> eventTypeFilters,
  ) {
    if (eventTypeFilters.isEmpty) {
      return eventsList;
    }

    return eventsList
        .where((event) => eventTypeFilters.contains(event.type))
        .toList();
  }

  static List<EventEntity> _filterByStatus(
    List<EventEntity> eventsList,
    bool showAnswered,
    bool showUndefined,
  ) {
    return eventsList.where((event) {
      if (showUndefined && event.status == EventStatusEnum.undefined) {
        return true;
      }
      if (showAnswered &&
          ([
            EventStatusEnum.accepted,
            EventStatusEnum.declined,
            EventStatusEnum.warning,
            EventStatusEnum.unknown
          ].contains(event.status))) {
        return true;
      }
      return !showUndefined && !showAnswered;
    }).toList();
  }

  static List<EventEntity> _getEventsByDateRange(
      DateTimeRange dateRange, List<EventEntity> eventsList) {
    return eventsList.where((event) {
      DateTime eventDate = DateTime.utc(
          event.startDate.year, event.startDate.month, event.startDate.day);
      return eventDate.isAfter(dateRange.start) &&
              eventDate.isBefore(dateRange.end) ||
          eventDate.isAtSameMomentAs(dateRange.start) ||
          eventDate.isAtSameMomentAs(dateRange.end);
    }).toList();
  }
}
