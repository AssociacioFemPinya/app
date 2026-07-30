import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/core/service_locator.dart' hide sl;
import 'package:fempinya3_flutter_app/features/login/login.dart';
import 'package:fempinya3_flutter_app/main_routes.dart';
import 'mock_entities.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserEntity extends Mock implements UserEntity {}

class MockLoginFormBloc extends MockBloc<LoginFormEvent, LoginFormState>
    implements LoginFormBloc {}

class FakeLoginFormState extends Fake implements LoginFormState {
  final MailValidationError? mailError;

  FakeLoginFormState({this.mailError});

  @override
  FormzSubmissionStatus get status => FormzSubmissionStatus.initial;

  @override
  bool get isValid => false;

  @override
  Mail get mail {
    final mail = Mail.dirty('');
    if (mailError != null) {
      return CustomMail(mailError!);
    }
    return mail;
  }

  @override
  Password get password => Password.pure();
}

class CustomMail extends Mail {
  final MailValidationError error;

  CustomMail(this.error) : super.dirty('');

  @override
  MailValidationError? validator(String value) {
    return error;
  }
}

void main() {
  late MockAuthenticationRepository authenticationRepository;
  late AuthenticationBloc authenticationBloc;
  late LoginFormBloc loginFormBloc;
  late GoRouter goRouter;
  late MockUnauthenticatedBloc mockUnauthenticatedBloc;
  late MockAuthenticationBloc mockAuthenticatedBloc;

  setUpAll(() {
    setupCommonServiceLocator();
    setupLoginServiceLocator(true);
    final Dio _dio = sl<Dio>();
    _dio.interceptors.clear();
    _dio.interceptors.add(UsersDioMockInterceptor());
    _dio.interceptors.add(TokensDioMockInterceptor());
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  group('AuthenticationBloc', () {
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
    });

    tearDown(() {
      authenticationBloc.close();
    });

    test('initial state is AuthenticationState.unknown', () {
      expect(authenticationBloc.state, const AuthenticationState.unknown());
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits AuthenticationState.unauthenticated when status is unauthenticated',
      build: () => authenticationBloc,
      act: (bloc) => bloc.add(AuthenticationSubscriptionRequested()),
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(
            AuthenticationResult(
              status: AuthenticationStatus.unauthenticated,
              userEntity: null,
            ),
          ),
        );
      },
      expect: () => [
        const AuthenticationState.unauthenticated(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits AuthenticationState.authenticated when status is authenticated',
      build: () => authenticationBloc,
      act: (bloc) => bloc.add(AuthenticationSubscriptionRequested()),
      setUp: () {
        final userEntity = MockUserEntity();
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(
            AuthenticationResult(
              status: AuthenticationStatus.authenticated,
              userEntity: userEntity,
            ),
          ),
        );
      },
      expect: () => [
        isA<AuthenticationState>().having(
          (state) => state.status,
          'status',
          AuthenticationStatus.authenticated,
        ),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits AuthenticationState.unknown when status is unknown',
      build: () => authenticationBloc,
      act: (bloc) => bloc.add(AuthenticationSubscriptionRequested()),
      setUp: () {
        when(() => authenticationRepository.status).thenAnswer(
          (_) => Stream.value(
            AuthenticationResult(
              status: AuthenticationStatus.unknown,
              userEntity: null,
            ),
          ),
        );
      },
      expect: () => [
        const AuthenticationState.unknown(),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logOut when AuthenticationLogoutPressed is added',
      build: () => authenticationBloc,
      setUp: () {
        when(() => authenticationRepository.logOut())
            .thenAnswer((_) async => Future.value());
      },
      act: (bloc) {
        bloc.add(AuthenticationLogoutPressed());
      },
      expect: () => [
        AuthenticationState(
            status: AuthenticationStatus.unauthenticated, user: null)
      ],
      verify: (bloc) {
        verify(() => authenticationRepository.logOut()).called(1);
      },
    );
  });
  group('LoginFormBloc', () {
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      loginFormBloc =
          LoginFormBloc(authenticationRepository: authenticationRepository);
    });

    tearDown(() {
      loginFormBloc.close();
    });
    blocTest<LoginFormBloc, LoginFormState>(
      'givenInvalidMail_whenLoginMailChangedEvent_thenFormBlocEmitsLoginFormStateWithInvalidStatus',
      build: () => loginFormBloc,
      act: (bloc) {
        bloc.add(LoginMailChanged('invalid-mail'));
      },
      expect: () => [
        LoginFormState(
          mail: Mail.dirty('invalid-mail'),
          password: Password.pure(),
          isValid: false,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.mail.value, 'invalid-mail');
        expect(state.isValid, false);
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenInvalidPassword_whenLoginPasswordChangedEvent_thenFormBlocEmitsLoginFormStateWithInvalidStatus',
      build: () => loginFormBloc,
      act: (bloc) {
        bloc.add(LoginPasswordChanged(''));
      },
      expect: () => [
        LoginFormState(
          mail: Mail.pure(),
          password: Password.dirty(''),
          isValid: false,
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.password.value, '');
        expect(state.isValid, false);
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenValidMailAndPassword_whenLoginBothEvents_thenFormBlocEmitsLoginFormStateWithValidStatus',
      build: () => loginFormBloc,
      act: (bloc) {
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginMailChanged('test@example.com'));
      },
      expect: () => [
        LoginFormState(
          mail: Mail.pure(),
          password: Password.dirty('password123'),
          isValid: false,
        ),
        LoginFormState(
          mail: Mail.dirty('test@example.com'),
          password: Password.dirty('password123'),
          isValid: true, // Adjust based on your validation logic
        ),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state.password.value, 'password123');
        expect(state.mail.value, 'test@example.com');
        expect(state.isValid, Formz.validate([state.password, state.mail]));
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenSuccessfulLogin_whenLoginSubmitted_thenEmits[inProgress,Success]',
      build: () {
        when(() => authenticationRepository.logIn(
              mail: any(named: 'mail'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Future.value());
        return loginFormBloc;
      },
      act: (bloc) {
        bloc.add(LoginMailChanged('test@example.com'));
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginSubmitted());
      },
      expect: () => [
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having((state) => state.status, 'status',
            FormzSubmissionStatus.inProgress),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.success),
      ],
      verify: (_) {
        verify(() => authenticationRepository.logIn(
              mail: 'test@example.com',
              password: 'password123',
            )).called(1);
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenFailLogin_whenLoginSubmitted_thenEmits[inProgress,Failure]',
      build: () {
        when(() => authenticationRepository.logIn(
              mail: any(named: 'mail'),
              password: any(named: 'password'),
            )).thenThrow(AuthenticationException('AuthenticationException'));
        return loginFormBloc;
      },
      act: (bloc) {
        bloc.add(LoginMailChanged('test@example.com'));
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginSubmitted());
      },
      expect: () => [
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having((state) => state.status, 'status',
            FormzSubmissionStatus.inProgress),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.failure),
      ],
      verify: (_) {
        verify(() => authenticationRepository.logIn(
              mail: 'test@example.com',
              password: 'password123',
            )).called(1);
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenError_whenLoginSubmitted_thenEmits[inProgress,Failure]',
      build: () {
        when(() => authenticationRepository.logIn(
              mail: any(named: 'mail'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Exception'));
        return loginFormBloc;
      },
      act: (bloc) {
        bloc.add(LoginMailChanged('test@example.com'));
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginSubmitted());
      },
      expect: () => [
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
        isA<LoginFormState>().having((state) => state.status, 'status',
            FormzSubmissionStatus.inProgress),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.failure),
      ],
      verify: (_) {
        verify(() => authenticationRepository.logIn(
              mail: 'test@example.com',
              password: 'password123',
            )).called(1);
      },
    );
    blocTest<LoginFormBloc, LoginFormState>(
      'givenLoginForm_whenReset_thenEmits[initial]',
      build: () => loginFormBloc,
      act: (bloc) {
        // Simulate a state where the status is not initial
        bloc.emit(loginFormBloc.state
            .copyWith(status: FormzSubmissionStatus.success));
        bloc.add(LoginResetStatus());
      },
      expect: () => [
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.success),
        isA<LoginFormState>().having(
            (state) => state.status, 'status', FormzSubmissionStatus.initial),
      ],
    );
  });
  group('Pages', () {
    late MockLoginFormBloc mockLoginFormBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      mockUnauthenticatedBloc = MockUnauthenticatedBloc(
        authenticationRepository: authenticationRepository,
      );
      mockAuthenticatedBloc = MockAuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
      goRouter = appRouter(mockUnauthenticatedBloc);
      mockLoginFormBloc = MockLoginFormBloc();
    });

    tearDown(() {
      mockUnauthenticatedBloc.close();
      mockLoginFormBloc.close();
    });

    // testWidgets('route returns a MaterialPageRoute with SplashPage',
    //     (WidgetTester tester) async {
    //   // Pump a simple widget to get a BuildContext
    //   await tester.pumpWidget(const MaterialApp(home: SizedBox()));

    //   // Obtain the BuildContext from the pumped widget
    //   final context = tester.element(find.byType(SizedBox));

    //   // Call the route method
    //   final route = SplashPage.route();

    //   // Verify the route is a MaterialPageRoute
    //   expect(route, isA<MaterialPageRoute<void>>());

    //   // Build the route to get the widget
    //   final materialRoute = route as MaterialPageRoute<void>;
    //   final widget = materialRoute.builder(context);

    //   // Verify the widget is a SplashPage
    //   expect(widget, isA<SplashPage>());
    // });

    testWidgets('givenUnauthenticated_whenSplashRoute_thenSplashPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<AuthenticationBloc>(
          create: (context) => mockUnauthenticatedBloc,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: loginRoutes,
              initialLocation: splashRoute,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pump(Duration(seconds: 2));
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('givenUnauthenticated_whenLoginRoute_thenLoginPage',
        (WidgetTester tester) async {
      await tester.pumpWidget(MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>.value(
              value: authenticationRepository)
        ],
        child: BlocProvider<AuthenticationBloc>(
          create: (context) => mockUnauthenticatedBloc,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: loginRoutes,
              initialLocation: loginRoute,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ));
      await tester.pump(Duration(seconds: 2));
      expect(find.byType(LoginPage), findsOneWidget);
    });
    testWidgets('givenLoginForm_whenInitialState_thenMailPasswordButtonExists',
        (tester) async {
      when(() => mockLoginFormBloc.state).thenReturn(FakeLoginFormState());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginFormBloc>(
            create: (_) => mockLoginFormBloc,
            child: const LoginForm(),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      expect(find.byKey(const Key('loginForm_mailInput_textField')),
          findsOneWidget);
      expect(find.byKey(const Key('loginForm_passwordInput_textField')),
          findsOneWidget);
      expect(find.byKey(const Key('loginForm_continue_raisedButton')),
          findsOneWidget);
    });

    testWidgets('prefills local test credentials when provided',
        (tester) async {
      when(() => mockLoginFormBloc.state).thenReturn(FakeLoginFormState());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginFormBloc>(
            create: (_) => mockLoginFormBloc,
            child: const LoginForm(
              initialMail: 'local-user@example.test',
              initialPassword: 'local-password',
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('loginForm_mailInput_textField')),
            )
            .initialValue,
        'local-user@example.test',
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('loginForm_passwordInput_textField')),
            )
            .initialValue,
        'local-password',
      );
    });

    testWidgets('displays error message for invalid email', (tester) async {
      final state = FakeLoginFormState();
      // when(() => state.mail.displayError).thenReturn(MailValidationError.empty);
      when(() => mockLoginFormBloc.state).thenReturn(
          FakeLoginFormState(mailError: MailValidationError.invalid));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<LoginFormBloc>(
            create: (_) => mockLoginFormBloc,
            child: const LoginForm(),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      await tester.enterText(
          find.byKey(const Key('loginForm_mailInput_textField')),
          'invalid-email');
      await tester.pump(Duration(seconds: 10));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
