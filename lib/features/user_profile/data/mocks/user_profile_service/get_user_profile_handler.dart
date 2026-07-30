import 'package:dio/dio.dart';

import 'package:femcastells/features/user_profile/user_profile.dart';

abstract class GetUserProfileHandler {
  static void handle(
    UserProfileDioMockInterceptor mock,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    Map<String, dynamic> userProfile = mock.userProfile;

    Response<dynamic> response;

    // Create a response object
    response = Response(
      requestOptions: options,
      data: userProfile,
      statusCode: 200,
    );

    // Complete the request with the mock response
    handler.resolve(response);
    return;
  }
}
