import 'package:dartz/dartz.dart';

import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/features/rondes/rondes.dart';

class GetRondaParams {
  final int? id;

  GetRondaParams({
    this.id,
  });
}

class GetRonda implements UseCase<Either, GetRondaParams> {
  final RondesRepository repository = sl<RondesRepository>();

  @override
  Future<Either> call({required GetRondaParams params}) async {
    return await repository.getRonda(params);
  }
}
