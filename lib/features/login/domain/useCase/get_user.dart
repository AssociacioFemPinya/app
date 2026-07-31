import 'package:femcastells/features/login/login.dart';
import 'package:femcastells/core/usecase/usecase.dart';

import 'package:dartz/dartz.dart';

class GetUserParams {
  
  GetUserParams();
}

class GetUser implements UseCase<Either, GetUserParams> {
  final UsersRepository repository = sl<UsersRepository>();

  @override
  Future<Either> call({required GetUserParams params}) async {
    return await repository.getUser(params);
  }
}
