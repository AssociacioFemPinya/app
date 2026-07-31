import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:femcastells/features/user_profile/user_profile.dart';

part 'user_profile_view_event.dart';
part 'user_profile_view_state.dart';

class UserProfileViewBloc
    extends Bloc<UserProfileViewEvent, UserProfileViewState> {
  UserProfileViewBloc() : super(UserProfileViewInitial()) {
    on<LoadUserProfile>(_onLoadUser);
  }
}

Future<void> _onLoadUser(
    LoadUserProfile event, Emitter<UserProfileViewState> emit) async {
  emit(UserProfileLoadInProgress());
  try {
    var result =
        await sl<GetUserProfile>().call(params: GetUserProfileParams());
    result.fold(
      (failure) => emit(UserProfileLoadFailure(failure)),
      (user) => emit(UserProfileLoadSuccess(user)),
    );
  } catch (e) {
    emit(UserProfileLoadFailure(e.toString()));
  }
}
