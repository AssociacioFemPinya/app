import 'package:femcastells/features/login/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:femcastells/l10n/app_localizations.dart';

const _storage = FlutterSecureStorage();
const _kEmail = 'saved_email';
const _kPassword = 'saved_password';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final email    = await _storage.read(key: _kEmail);
    final password = await _storage.read(key: _kPassword);
    if (email != null && mounted) {
      _emailCtrl.text = email;
      context.read<LoginFormBloc>().add(LoginMailChanged(email));
    }
    if (password != null && mounted) {
      _passwordCtrl.text = password;
      context.read<LoginFormBloc>().add(LoginPasswordChanged(password));
    }
  }

  Future<void> _saveCredentials(LoginFormState state) async {
    await _storage.write(key: _kEmail,    value: state.mail.value);
    await _storage.write(key: _kPassword, value: state.password.value);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          _saveCredentials(state);
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(translate.loginSnackBarError)),
            );
          context.read<LoginFormBloc>().add(const LoginResetStatus());
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  translate.loginPageTitle,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _MailInput(controller: _emailCtrl),
                const SizedBox(height: 12),
                _PasswordInput(controller: _passwordCtrl),
                const SizedBox(height: 16),
                _LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MailInput extends StatelessWidget {
  final TextEditingController controller;
  const _MailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final isError =
        context.select((LoginFormBloc b) => b.state.mail.displayError) != null;
    return TextField(
      key: const Key('loginForm_mailInput_textField'),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onChanged: (mail) =>
          context.read<LoginFormBloc>().add(LoginMailChanged(mail)),
      decoration: InputDecoration(
        labelText: translate.loginPageEmailTitle,
        errorText: isError ? translate.loginPageInvalidMail : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  const _PasswordInput({required this.controller});

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final isError = context.select(
          (LoginFormBloc bloc) => bloc.state.password.displayError,
        ) !=
        null;
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      controller: widget.controller,
      onChanged: (password) =>
          context.read<LoginFormBloc>().add(LoginPasswordChanged(password)),
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: translate.loginPagePasswordTitle,
        errorText: isError ? translate.loginPageInvalidPassword : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final isInProgressOrSuccess = context.select(
      (LoginFormBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) {
      EasyLoading.show(status: 'Loading...');
    } else {
      EasyLoading.dismiss();
    }

    final isValid =
        context.select((LoginFormBloc bloc) => bloc.state.isValid);

    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: isValid
          ? () => context.read<LoginFormBloc>().add(const LoginSubmitted())
          : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(translate.loginPageLoginButton),
    );
  }
}
