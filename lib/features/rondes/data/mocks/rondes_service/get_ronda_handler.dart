import 'package:dio/dio.dart';

import 'package:femcastells/features/rondes/rondes.dart';

abstract class GetRondaHandler {
  static void handle(
    RondesDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Extract the integer ID from the path
    final idPart = options.path.split('/').last;
    int? rondaID;

    // Try to parse the ID as an integer
    try {
      rondaID = int.parse(idPart);
    } catch (e) {
      // If parsing fails, set rondaID to null
      rondaID = null;
    }

    // Initialize the response with a bad request status
    Response response = Response(
      requestOptions: options,
      statusCode: 400,
      data: {'error': 'Invalid ID format'},
    );

    // Check if rondaID is null or invalid
    if (rondaID == null) {
      handler.resolve(response);
      return;
    }

    // Try to find the event that match rondaID
    for (var ronda in mock.rondesList) {
      if (ronda['id'] == rondaID) {
        response = Response(
          requestOptions: options,
          data: ronda,
          statusCode: 200,
        );
        handler.resolve(response);
        return;
      }
    }

    // Coudn't find the ronda so return not-found
    response = Response(
      requestOptions: options,
      statusCode: 404,
    );
    handler.resolve(response);
  }
}
