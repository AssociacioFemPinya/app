import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:femcastells/features/rondes/rondes.dart';

class RondesDioMockInterceptor extends Interceptor {
  late List<Map> rondesList;
  late Map<String, dynamic> publicDisplayUrl;

  int percentageOfRandomFailures = 0;
  int maxDurationRequest = 200;

  Map<
      _MockRouteKey,
      void Function(RondesDioMockInterceptor mock, RequestOptions options,
          RequestInterceptorHandler handler)> mockRouter = {
    _MockRouteKey(RondesApiEndpoints.getRondes, 'GET'):
        GetRondesListHandler.handle,
    _MockRouteKey(RondesApiEndpoints.getPublicDisplayUrl, 'GET'):
        GetPublicDisplayUrlHandler.handle,
  };

  RondesDioMockInterceptor() {
    rondesList = _generateRondes();
    publicDisplayUrl = _generatePublicDisplayUrl();
  }

  List<Map<String, dynamic>> _generateRondes() {
    List<Map<String, dynamic>> rondaMapList =
        List<Map<String, dynamic>>.generate(2, (index) {
      return {
        'id': index, // Adjusted to start from 1
        'name': 'Lorem ipsum dolor',
        'publicUrl':
            'https://app.fempinya.cat/public/display/AireNou/WWN5Wk9aTnl4Q3FHUTE5bklsTkdCOFEvQ1BLWVB4M1BveVpRYlNJbkE1bDZ2SVBNTUlIbzI3S1RXUGRlVlBsUQ==',
        'ronda': index, // Adjusted to start from 1
      };
    });

    rondaMapList.add({
      'id': 2,
      'name': 'sit amet.',
      'publicUrl': '',
      'ronda': 2,
    });

    rondaMapList.add({
      'id': 3,
      'name': 'Sed quisquam',
      'publicUrl': 'mail@mail.com',
      'ronda': 3,
    });

    return rondaMapList;
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

    // Custom logic to handle dynamic paths
    if (options.path.startsWith(RondesApiEndpoints.getRondes + '/') &&
        options.method == 'GET') {
      GetRondaHandler.handle(this, options, handler);
      EasyLoading.dismiss();
      return;
    }

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

  Map<String, dynamic> _generatePublicDisplayUrl() {
    return {
      'publicUrl':
          'https://dev.fempinya.cat/public/display/CdLLeida/cTlTOGl2SHd1Y1o0U0s5WFRyYTFQN3JuRjVwaDloS2xXTUFncWhtbzBuSEc4WTVvV2N3djlEOVZyd1Vic0RoNk1yZncycUd3MEF0NFZJa1RBRDZiMlE9PQ==',
    };
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
