import 'package:femcastells/features/login/login.dart';

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TokensDioMockInterceptor extends Interceptor {
  late TokenEntity token;

  int percentageOfRandomFailures = 0;
  int maxDurationRequest = 200;

  Map<
      _MockRouteKey,
      void Function(TokensDioMockInterceptor mock, RequestOptions options,
          RequestInterceptorHandler handler)> mockRouter = {
    _MockRouteKey('/api/auth/login', 'POST'): GetTokenHandler.handle,
  };

  TokensDioMockInterceptor() {
    token = _generateToken();
  }

  TokenEntity _generateToken() {
    return TokenEntity(
        access_token: '99|rud6x5D51FyoLHJH1hCncsVfplhdYhuMiUEAG5avbeb88326',
        token_type: 'Bearer');
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
