import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:femcastells/features/events/data/mocks/events_service/events_service.dart';

abstract class GetEventHandler {

  static void handle(
    EventsDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final queryParams = options.queryParameters;
    Response<dynamic> response;

    // If query param doesn't contain eventID, return none
    if (!queryParams.containsKey("id")) {
      response = Response(
        requestOptions: options,
        statusCode: 500,
      );
      handler.resolve(response);
      return;
    }

    // Try to find the event that match eventID
    int eventID = queryParams["id"];
    for (var event in mock.eventList) {
      if (event.id == eventID) {
        response = Response(
          requestOptions: options,
          data: jsonEncode(event.toModel().toJson()),
          statusCode: 200,
        );
        handler.resolve(response);
        return;
      }
    }

    // Coudn't find the event so return not-found
    response = Response(
      requestOptions: options,
      statusCode: 500,
    );
    handler.resolve(response);
  }
}
