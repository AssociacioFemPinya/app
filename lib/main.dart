import 'package:fempinya3_flutter_app/core/service_locator.dart';
import 'package:fempinya3_flutter_app/features/events/service_locator.dart';
import 'package:fempinya3_flutter_app/features/login/login.dart';
import 'package:fempinya3_flutter_app/features/rondes/rondes.dart';
import 'package:fempinya3_flutter_app/features/user_profile/user_profile.dart';
import 'package:fempinya3_flutter_app/main_routes.dart';
import 'package:fempinya3_flutter_app/features/menu/domain/entities/locale.dart';
import 'package:fempinya3_flutter_app/services/firebase_notification_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fempinya3_flutter_app/features/notifications/service_locator.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
late bool useMockApi;

class AuthInitializationResult {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationBloc authenticationBloc;

  AuthInitializationResult(
      {required this.authenticationRepository,
      required this.authenticationBloc});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await FirebaseNotificationService.instance.initialize();
  }

  const bool useMockApi =
      bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

  setupCommonServiceLocator();
  setupEventsServiceLocator(useMockApi);
  setupLoginServiceLocator(useMockApi);
  setupRondesServiceLocator(useMockApi);
  setupNotificationsServiceLocator(useMockApi);
  setupUserProfileServiceLocator(useMockApi);
  configLoading();

  runApp(const App());
}

Future<void> requestNotificationPermissions(FirebaseMessaging messaging) async {
  
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..indicatorColor = Colors.indigo
    ..backgroundColor = Colors.transparent
    ..textColor = Colors.transparent
    ..maskType = EasyLoadingMaskType.none
    ..maskColor = Colors.transparent
    ..indicatorSize = 30.0
    ..radius = 10.0
    ..userInteractions = false
    ..boxShadow = <BoxShadow>[]
    ..dismissOnTap = false;
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  Future<AuthInitializationResult> initAuthenticationRepository() async {
    // FP and Firebase token are saved in shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    // Init authentication repository with shared preferences
    final authenticationRepository =
        AuthenticationRepository(sharedPreferences);
    // Init authentication Bloc with repository
    final authenticationBloc =
        AuthenticationBloc(authenticationRepository: authenticationRepository);
    // Init router with authentication bloc
    if (!sl.isRegistered<GoRouter>()) {
      sl.registerSingleton<GoRouter>(appRouter(authenticationBloc));

      // Process any pending notifications after the router is registered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FirebaseNotificationService.processPendingNotifications();
      });
    }

    return AuthInitializationResult(
      authenticationRepository: authenticationRepository,
      authenticationBloc: authenticationBloc,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Future<AuthInitializationResult> initializationFuture =
        initAuthenticationRepository();

    return FutureBuilder<AuthInitializationResult>(
      future: initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          AuthenticationRepository authenticationRepository =
              snapshot.data!.authenticationRepository;
          AuthenticationBloc authenticationBloc =
              snapshot.data!.authenticationBloc;
          return RepositoryProvider.value(
            value: authenticationRepository,
            child: BlocProvider.value(
              value: authenticationBloc
                ..add(AuthenticationSubscriptionRequested()),
              child: const MyApp(),
            ),
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) {
          return MaterialApp.router(
            title: 'FemPinya App',
            routerConfig: sl<GoRouter>(), // Use the GoRouter configuration
            builder: EasyLoading.init(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeModel.locale,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system, //or ThemeMode.dark
            //theme: GlobalThemeData.lightThemeData,
            //darkTheme: GlobalThemeData.darkThemeData,
            //To-do Zan
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.light,
                dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
                dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
              ),
              useMaterial3: true,
            ),
          );
          // );
        },
      ),
    );
  }
}
