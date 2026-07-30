import 'package:dartz/dartz.dart';

import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';

class GetUserProfileParams {
  GetUserProfileParams();
}

class GetUserProfile implements UseCase<Either, GetUserProfileParams> {
  final UserProfileRepository repository = sl<UserProfileRepository>();

  @override
  Future<Either> call({required GetUserProfileParams params}) async {
    return await repository.getUserProfile(params);
  }
}
