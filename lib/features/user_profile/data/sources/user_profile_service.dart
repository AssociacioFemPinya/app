import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:fempinya3_flutter_app/features/user_profile/user_profile.dart';

abstract class UserProfileService {
  Future<Either<String, UserProfileEntity>> getUserProfile(
      GetUserProfileParams params);
}

class UserProfileServiceImpl implements UserProfileService {
  final Dio _dio = sl<Dio>();
  final Logger _logger = sl<Logger>();

  void _logError(String message, dynamic error, StackTrace stacktrace) {
    _logger.e(message, error, stacktrace);
  }

  @override
  Future<Either<String, UserProfileEntity>> getUserProfile(
      GetUserProfileParams params) async {
    try {
      final response = await _dio.get(UserProfileApiEndpoints.getUserProfile);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        return Right(
            UserProfileEntity.fromModel(UserProfileModel.fromJson(data)));
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling ${UserProfileApiEndpoints.getUserProfile} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling ${UserProfileApiEndpoints.getUserProfile} endpoint: $e');
    }
  }
}
