import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:femcastells/features/rondes/rondes.dart';
import 'package:femcastells/features/rondes/data/models/historial.dart';

abstract class RondesService {
  Future<Either<String, List<RondaEntity>>> getRondesList(
      GetRondesListParams params);
  Future<Either<String, RondaEntity>> getRonda(GetRondaParams params);
  Future<Either<String, PublicDisplayUrlEntity>> getPublicDisplayUrl(
      GetPublicDisplayUrlParams params);
  Future<Either<String, List<HistorialEventModel>>> getHistorial();
}

class RondesServiceImpl implements RondesService {
  final Dio _dio = sl<Dio>();
  final Logger _logger = sl<Logger>();

  @override
  Future<Either<String, List<RondaEntity>>> getRondesList(
      GetRondesListParams params) async {
    try {
      final response = await _dio.get(RondesApiEndpoints.getRondes);
      if (response.statusCode == 200 && response.data is List) {
        final jsonList = response.data as List<dynamic>;
        final pinyes = jsonList
            .map((json) => RondaEntity.fromModel(
                RondaModel.fromJson(json as Map<String, dynamic>)))
            .toList();
        return Right(pinyes);
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError('Error when calling ${RondesApiEndpoints.getRondes} endpoint',
          e, stacktrace);
      return Left(
          'Error when calling ${RondesApiEndpoints.getRondes} endpoint: $e');
    }
  }

  @override
  Future<Either<String, List<HistorialEventModel>>> getHistorial() async {
    try {
      final response = await _dio.get(RondesApiEndpoints.getHistorial);
      if (response.statusCode == 200 && response.data is List) {
        final list = (response.data as List)
            .map((e) => HistorialEventModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError('Error when calling ${RondesApiEndpoints.getHistorial}', e, stacktrace);
      return Left('Error when calling ${RondesApiEndpoints.getHistorial}: $e');
    }
  }

  void _logError(String message, dynamic error, StackTrace stacktrace) {
    _logger.e(message, error, stacktrace);
  }

  @override
  Future<Either<String, RondaEntity>> getRonda(GetRondaParams params) async {
    try {
      final response = await _dio
          .get("${RondesApiEndpoints.getRondes}/${params.id.toString()}");
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;
        return Right(RondaEntity.fromModel(RondaModel.fromJson(json)));
        // final json =
        //     jsonDecode(response.data as String) as Map<String, dynamic>;
        // return Right(RondaEntity.fromModel(RondaModel.fromJson(json)));
      } else if (response.statusCode == 404) {
        return Left('Unknown ronda id');
      } else if (response.statusCode == 400) {
        return Left('Any ronda id provided');
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling ${RondesApiEndpoints.getRondes}/${params.id.toString()} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling ${RondesApiEndpoints.getRondes}/${params.id.toString()} endpoint: $e');
    }
  }

  @override
  Future<Either<String, PublicDisplayUrlEntity>> getPublicDisplayUrl(
      GetPublicDisplayUrlParams params) async {
    try {
      final response = await _dio.get(RondesApiEndpoints.getPublicDisplayUrl);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;
        return Right(PublicDisplayUrlEntity.fromModel(
            PublicDisplayUrlModel.fromJson(json)));
      }
      return const Left('Unexpected response format');
    } catch (e, stacktrace) {
      _logError(
          'Error when calling ${RondesApiEndpoints.getPublicDisplayUrl} endpoint',
          e,
          stacktrace);
      return Left(
          'Error when calling ${RondesApiEndpoints.getPublicDisplayUrl} endpoint: $e');
    }
  }
}
