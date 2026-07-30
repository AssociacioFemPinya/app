import 'package:dartz/dartz.dart';

import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/features/rondes/rondes.dart';

class GetPublicDisplayUrlParams {

  GetPublicDisplayUrlParams();
}

class GetPublicDisplayUrl
    implements UseCase<Either, GetPublicDisplayUrlParams> {
  final RondesRepository repository = sl<RondesRepository>();

  @override
  Future<Either> call({required GetPublicDisplayUrlParams params}) async {
    return await repository.getPublicDisplayUrl(params);
  }
}
