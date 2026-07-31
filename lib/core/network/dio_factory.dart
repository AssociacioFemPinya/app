import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fempinya3_flutter_app/global_endpoints.dart';
import 'package:fempinya3_flutter_app/core/network/loading_interceptor.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getInstance() {
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: GlobalEndpoints.apiBaseUrl,
        connectTimeout: Duration(milliseconds: 20000),
        receiveTimeout: Duration(milliseconds: 20000),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '12345',
        },
      );
      _dio = Dio(options);

      _dio!.interceptors.add(LogInterceptor(
        // request: true,
        // requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));

      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Récupérer le token d'authentification
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ));

      // Add interceptors, set base options, etc.
      _dio!.interceptors.add(LoadingInterceptor());
    }

    return _dio!;
  }
}
