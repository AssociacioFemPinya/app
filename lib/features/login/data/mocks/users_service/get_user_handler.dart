import 'package:femcastells/features/login/login.dart';

import 'package:dio/dio.dart';

abstract class GetUserHandler {
  static void handle(
    UsersDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    Response<dynamic> response;

    final userEntity = mock.user;

    final responseData = userEntity.toModel().toJson();

    response = Response(
      requestOptions: options,
      data: responseData,
      statusCode: 200,
    );
    handler.resolve(response);
    return;
  }
}
