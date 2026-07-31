import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:femcastells/features/login/login.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationResult {
  final AuthenticationStatus status;
  final UserEntity? userEntity;

  AuthenticationResult({required this.status, this.userEntity});

  @override
  String toString() {
    return 'AuthenticationResult($status, userEntity: "$userEntity")';
  }

  // Override the equality operator to compare two AuthenticationResult objects
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationResult &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          userEntity == other.userEntity;

  @override
  int get hashCode => status.hashCode ^ userEntity.hashCode;
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationResult>();
  final SharedPreferences sharedPreferences;

  AuthenticationRepository(this.sharedPreferences);

  Stream<AuthenticationResult> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    
    // Check if the token exists in SharedPreferences
    String? token = _fetchAuthToken();

    if (token != null) {
      try {
        // // Token exists, attempt to fetch user data
        Future<UserEntity> userEntity = _fetchUserData();
        // Fetching user data succeeded, emit authenticated status with user data
        yield AuthenticationResult(
          status: AuthenticationStatus.authenticated,
          userEntity: await userEntity,
        );
      } on AuthenticationException {
        // Fetching user data failed, delete the token and emit unauthenticated status
        yield AuthenticationResult(
            status: AuthenticationStatus.unauthenticated);
      }
    } else {
      // Token does not exist, emit unauthenticated status
      yield AuthenticationResult(status: AuthenticationStatus.unauthenticated);
    }

    yield* _controller.stream;
  }

  String? _fetchAuthToken() {
    String? token = sharedPreferences.getString('auth_token');
    return token;
  }

  Future<void> logIn({
    required String mail,
    required String password,
  }) async {
    GetTokenParams getTokenParams =
        GetTokenParams(mail: mail, password: password);

    var tokenResult = await sl<GetToken>().call(params: getTokenParams);

    await _handleGetTokenResult(tokenResult, mail, password);
  }

  Future<void> _handleGetTokenResult(
      Either<dynamic, dynamic> result, String mail, String password) async {
    await result.fold(
      (failure) async {
        _controller.add(
            AuthenticationResult(status: AuthenticationStatus.unauthenticated));
        throw AuthenticationException('Invalid username or password');
      },
      (data) async {
        await _saveAuthToken(data.access_token);
        try {
          UserEntity userEntity = await _fetchUserData();
          _controller.add(AuthenticationResult(
            status: AuthenticationStatus.authenticated,
            userEntity: userEntity,
          ));
        } on AuthenticationException {
          _controller.add(AuthenticationResult(
              status: AuthenticationStatus.unauthenticated));
          throw AuthenticationException(
              'Server provided a wrong token with this username and password.');
        }
        
      },
    );
  }

  Future<void> _saveAuthToken(String token) async {
    await sharedPreferences.setString('auth_token', token);
  }

  Future<UserEntity> _fetchUserData() async {
    final getUserParams = GetUserParams();
    final result = await sl<GetUser>().call(params: getUserParams);

    return result.fold(
      (failure) async {
        _controller.add(
            AuthenticationResult(status: AuthenticationStatus.unauthenticated));
        throw AuthenticationException('Invalid token');
      },
      (userData) => userData,
    );
  }

  Future<void> logOut() async {
    await sharedPreferences.remove('auth_token');
  }

  void dispose() => _controller.close();
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}
