import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:femcastells/features/events/data/mocks/events_service/events_service.dart';
import 'package:femcastells/features/events/data/models/event.dart';
import 'package:femcastells/features/events/domain/entities/event.dart';

abstract class PostEventHandler {
  static void handle(
    EventsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    var eventJson = jsonDecode(options.data);
    var event = EventEntity.fromModel(EventModel.fromJson(eventJson));

    var eventIndex = -1;
    for (int i = 0; i < mock.eventList.length; i++) {
      if (mock.eventList[i].id == event.id) {
        eventIndex = i;
        mock.eventList[i] = event;
        break;
      }
    }

    Response<dynamic> response;
    if (eventIndex >= 0) {
      mock.eventList[eventIndex] = event;
      response = Response(
        requestOptions: options,
        data: jsonEncode(event.toModel().toJson()),
        statusCode: 200,
      );
      handler.resolve(response);
      return;
    } else {
      response = Response(
        requestOptions: options,
        statusCode: 404,
      );
      handler.resolve(response);
      return;
    }
  }
}
