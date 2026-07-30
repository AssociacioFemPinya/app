import 'package:fempinya3_flutter_app/features/login/login.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'loginForm_event.dart';
part 'loginForm_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthenticationRepository _authenticationRepository;

  LoginFormBloc({
    required AuthenticationRepository authenticationRepository,
    String initialMail = '',
    String initialPassword = '',
  })  : _authenticationRepository = authenticationRepository,
        super(_initialState(initialMail, initialPassword)) {
    on<LoginMailChanged>(_onMailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginResetStatus>(_onResetStatus);
  }

  static LoginFormState _initialState(
      String initialMail, String initialPassword) {
    final mail =
        initialMail.isEmpty ? const Mail.pure() : Mail.dirty(initialMail);
    final password = initialPassword.isEmpty
        ? const Password.pure()
        : Password.dirty(initialPassword);

    return LoginFormState(
      mail: mail,
      password: password,
      isValid: Formz.validate([mail, password]),
    );
  }

  _onMailChanged(LoginMailChanged event, Emitter<LoginFormState> emit) {
    final mail = Mail.dirty(event.mail);

    emit(
      state.copyWith(
        mail: mail,
        isValid: Formz.validate([state.password, mail]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginFormState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.mail]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authenticationRepository.logIn(
          mail: state.mail.value,
          password: state.password.value,
        );

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on AuthenticationException {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  FutureOr<void> _onResetStatus(
      LoginResetStatus event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(status: FormzSubmissionStatus.initial));
  }
}
