import 'package:fempinya3_flutter_app/features/login/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const _localTestEmail = String.fromEnvironment('LOCAL_TEST_EMAIL');
  static const _localTestPassword =
      String.fromEnvironment('LOCAL_TEST_PASSWORD');

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => LoginFormBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            initialMail: _localTestEmail,
            initialPassword: _localTestPassword,
          ),
          child: const LoginForm(
            initialMail: _localTestEmail,
            initialPassword: _localTestPassword,
          ),
        ),
      ),
    );
  }
}
