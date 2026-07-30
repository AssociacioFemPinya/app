import 'package:femcastells/features/login/login.dart';

import 'package:dartz/dartz.dart';

abstract class UsersRepository {
  Future<Either> getUser(GetUserParams params);
  Future<Either> getToken(GetTokenParams params);
}
