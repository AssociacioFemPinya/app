import 'package:femcastells/features/login/login.dart';

import 'package:dio/dio.dart';

abstract class GetTokenHandler {
  static void handle(
    TokensDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final queryParams = options.queryParameters;

    if (queryParams.containsKey("email") &&
        queryParams["email"] == "alanbover@gmail.com") {
      _sendTokenSuccessfully(mock, options, handler);
    } else {
      _sendForbiddenUser(options, handler);
    }
  }

  static void _sendTokenSuccessfully(TokensDioMockInterceptor mock,
      RequestOptions options, RequestInterceptorHandler handler) {
    final tokenEntity = mock.token;

    final responseData = {
      "access_token": tokenEntity.access_token,
      "token_type": tokenEntity.token_type,
    };

    Response<dynamic> response = Response(
      requestOptions: options,
      data: responseData,
      statusCode: 200,
    );
    handler.resolve(response);
    return;
  }

  static void _sendForbiddenUser(
      RequestOptions options, RequestInterceptorHandler handler) {
    Response<dynamic> response = Response(
      requestOptions: options,
      statusCode: 403, // Forbidden, indicating the user is not authorized
    );
    handler.resolve(response);
    return;
  }
}
