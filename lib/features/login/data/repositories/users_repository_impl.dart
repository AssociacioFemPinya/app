import 'package:femcastells/features/login/login.dart';

import 'package:dartz/dartz.dart';

class UsersRepositoryImpl extends UsersRepository {
  @override
  Future<Either> getUser(GetUserParams params) async {
    return await sl<UsersService>().getUser(params);
  }
  
  @override
  Future<Either> getToken(GetTokenParams params) async {
    return await sl<UsersService>().getToken(params);
  }
}
