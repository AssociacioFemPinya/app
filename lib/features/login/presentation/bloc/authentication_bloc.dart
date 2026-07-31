import 'package:femcastells/features/login/login.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.authenticationRepository,
    UserEntity? userEntity,
  })  : userEntity = null,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository authenticationRepository;
  UserEntity? userEntity;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      authenticationRepository.status,
      onData: (status) async {
        switch (status.status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());

          case AuthenticationStatus.authenticated:
            userEntity = status.userEntity;
            return emit(AuthenticationState.authenticated(status.userEntity!));

          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  Future<void> _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authenticationRepository.logOut();
    userEntity = null;
    emit(AuthenticationState.unauthenticated());
  }
}
