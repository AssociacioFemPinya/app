import 'package:femcastells/features/login/login.dart';
import 'package:femcastells/core/usecase/usecase.dart';

import 'package:dartz/dartz.dart';

class GetTokenParams {
  final String? mail;
  final String? password;

  GetTokenParams({
    this.mail,
    this.password,
  });
}

class GetToken implements UseCase<Either, GetTokenParams> {
  final UsersRepository repository = sl<UsersRepository>();

  @override
  Future<Either> call({required GetTokenParams params}) async {
    return await repository.getToken(params);
  }
}
