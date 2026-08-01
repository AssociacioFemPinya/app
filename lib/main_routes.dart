import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/events/presentation/routes.dart';
import 'package:femcastells/features/home/presentation/pages/home_page.dart';
import 'package:femcastells/features/login/login.dart';
import 'package:femcastells/features/rondes/rondes.dart';
import 'package:femcastells/features/rondes/presentation/pages/historial_page.dart';
import 'package:femcastells/features/notifications/presentation/routes.dart';
import 'package:femcastells/features/user_profile/presentation/routes.dart';
import 'package:femcastells/features/gdpr/gdpr_consent_page.dart';
import 'package:femcastells/features/info/about_page.dart';
import 'package:femcastells/features/info/help_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

GoRouter appRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    initialLocation: splashRoute,
    observers: [routeObserver],
    routes: [
      GoRoute(
        name: homeRoute,
        path: homeRoute,
        builder: (context, state) => HomePage(),
      ),
      ...eventRoutes,
      ...loginRoutes,
      ...rondesRoutes,
      ...notificationRoutes,
      ...userProfileRoutes,
      GoRoute(
        name: historialRoute,
        path: historialRoute,
        builder: (context, state) => const HistorialPage(),
      ),
      GoRoute(
        name: gdprConsentRoute,
        path: gdprConsentRoute,
        builder: (context, state) => GdprConsentPage(fromMenu: state.extra == true),
      ),
      GoRoute(
        name: aboutRoute,
        path: aboutRoute,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        name: helpRoute,
        path: helpRoute,
        builder: (context, state) => const HelpPage(),
      ),
    ],
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: StreamToListenable([authenticationBloc.stream]),
    //The top-level callback allows the app to redirect to a new location.
    redirect: (context, state) {
      // Show loading screen on app startup
      if (authenticationBloc.state == const AuthenticationState.unknown()) {
        EasyLoading.show(status: 'Loading...');
        return splashRoute;
      }
      if (authenticationBloc.state ==
          const AuthenticationState.unauthenticated()) {
        // If the user is not authenticated, redirect to the login page
        EasyLoading.dismiss();
        return loginRoute;
      } else {
        // If the user is authenticated, redirect to the home page
        if (state.matchedLocation == loginRoute ||
            state.matchedLocation == splashRoute) {
          EasyLoading.dismiss();
          return homeRoute;
        }
      }
      // Otherwise do not modify the route
      return null;
    },
  );
}

// convert authenticationBloc stream to listenable
// due to GoRouter configuration requirements.
class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
