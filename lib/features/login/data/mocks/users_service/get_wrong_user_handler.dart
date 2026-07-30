import 'package:femcastells/features/login/login.dart';

import 'package:dio/dio.dart';

abstract class GetWrongUserHandler {
  static void handle(
    WrongUsersDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    Response<dynamic> response;

    response = Response(
      requestOptions: options,
      statusCode: 401,
    );
    handler.resolve(response);
    return;
  }
}
