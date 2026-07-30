import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:femcastells/features/user_profile/user_profile.dart';

class UserProfileDioMockInterceptor extends Interceptor {
  late Map<String, dynamic> userProfile;

  int percentageOfRandomFailures = 0;
  int maxDurationRequest = 200;

  Map<
      _MockRouteKey,
      void Function(UserProfileDioMockInterceptor mock, RequestOptions options,
          RequestInterceptorHandler handler)> mockRouter = {
    _MockRouteKey(UserProfileApiEndpoints.getUserProfile, 'GET'):
        GetUserProfileHandler.handle,
  };

  UserProfileDioMockInterceptor() {
    userProfile = generateUserProfile();
    userProfile["castellerInfo"] = jsonEncode(userProfile);
  }

  Map<String, dynamic> generateUserProfile() {
    return {
      'id_casteller': 3942,
      'id_casteller_external': 3678,
      'colla_id': 29,
      'num_soci': '12345',
      'nationality': 'Spanish',
      'national_id_number': 'X1234567Y',
      'national_id_type': 'DNI',
      'name': 'John',
      'last_name': 'Doe',
      'family': 'Doe Family',
      'family_head': 'Jane Doe',
      'alias': 'AIRUN',
      'gender': 1,
      'birthdate': '1990-01-15T00:00:00.000Z',
      'subscription_date': '2022-01-01T00:00:00.000Z',
      'email': 'john.doe@example.com',
      'email2': 'john.backup@example.com',
      'phone': '+34 123456789',
      'mobile_phone': '+34 987654321',
      'emergency_phone': '+34 112233445',
      'address': '123 Main Street',
      'postal_code': '08001',
      'city': 'Barcelona',
      'comarca': 'Barcelonès',
      'province': 'Barcelona',
      'country': 'Spain',
      'comments': 'No comments available.',
      'photo': 'path/to/dummy/photo.jpg',
      'height': 175,
      'weight': 70,
      'shoulder_height': 140,
      'status': 1,
      'language': 'Catalan',
      'interaction_type': 1,
      'created_at': '2023-06-20T21:05:41.000000Z',
      'updated_at': '2023-09-15T19:39:52.000000Z',
    };
  }

  @override
  Future<void> onRequest(
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
