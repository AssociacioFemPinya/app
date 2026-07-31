import 'package:femcastells/features/login/login.dart';

import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class UsersService {
  Future<Either<String, UserEntity>> getUser(GetUserParams params);
  Future<Either<String, TokenEntity>> getToken(GetTokenParams params);
}

class UsersServiceImpl implements UsersService {
  final Dio _dio = sl<Dio>();
  final Logger _logger = sl<Logger>();

  @override
  Future<Either<String, UserEntity>> getUser(GetUserParams params) async {
    try {
      final response = await _dio.get(LoginApiEndpoints.getUserContext);
      if (response.statusCode == 200 && response.data is Map) {
        final json = response.data as Map<String, dynamic>;
        return Right(UserEntity.fromModel(UserModel.fromJson(json)));
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling get ${LoginApiEndpoints.getUserContext} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling get ${LoginApiEndpoints.getUserContext} endpoint: $e');
    }
  }

  @override
  Future<Either<String, TokenEntity>> getToken(GetTokenParams params) async {
    try {
      final response = await _dio.post(
        LoginApiEndpoints.getToken,
        data: {'email': params.mail, 'password': params.password},
      );
      if (response.statusCode == 200 && response.data is Map) {
        final json = response.data as Map<String, dynamic>;
        return Right(TokenEntity.fromModel(TokenModel.fromJson(json)));
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError('Error when calling get ${LoginApiEndpoints.getToken} endpoint',
          e, stacktrace);
      return Left(
          'Error when calling get ${LoginApiEndpoints.getToken} endpoint: $e');
    }
  }

  void _logError(String message, dynamic error, StackTrace stacktrace) {
    _logger.e(message, error, stacktrace);
  }
}
