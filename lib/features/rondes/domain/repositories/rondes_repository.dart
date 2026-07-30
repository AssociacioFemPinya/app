import 'package:dartz/dartz.dart';
import 'package:femcastells/features/rondes/rondes.dart';

abstract class RondesRepository {
  Future<Either> getRondesList(GetRondesListParams params);
  Future<Either> getRonda(GetRondaParams params);
  Future<Either> getPublicDisplayUrl(GetPublicDisplayUrlParams params);
}
