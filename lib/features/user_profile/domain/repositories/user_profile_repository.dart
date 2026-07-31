import 'package:dartz/dartz.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either> getUserProfile(GetUserProfileParams params);
}
