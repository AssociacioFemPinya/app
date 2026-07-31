import 'package:dartz/dartz.dart';
import 'package:femcastells/features/rondes/rondes.dart';

class RondesRepositoryImpl extends RondesRepository {
  @override
  Future<Either> getRondesList(GetRondesListParams params) async {
    return await sl<RondesService>().getRondesList(params);
  }

  @override
  Future<Either> getRonda(GetRondaParams params) async {
    return await sl<RondesService>().getRonda(params);
  }
  
  @override
  Future<Either> getPublicDisplayUrl(GetPublicDisplayUrlParams params) async {
    return await sl<RondesService>().getPublicDisplayUrl(params);
  }
}
