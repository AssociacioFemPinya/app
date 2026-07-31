import 'package:dio/dio.dart';

import 'package:femcastells/features/rondes/rondes.dart';

abstract class GetRondesListHandler {
  static void handle(
    RondesDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final List<Map> rondes = mock.rondesList;

    Response<dynamic> response;

    // Create a response object
    response = Response(
      requestOptions: options,
      data:
          rondes,
      statusCode: 200,
    );

    // Complete the request with the mock response
    handler.resolve(response);
  }
}
