import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/routes.dart';
import 'package:fempinya3_flutter_app/features/home/presentation/pages/home_page.dart';
import 'package:fempinya3_flutter_app/features/login/login.dart';
import 'package:fempinya3_flutter_app/features/rondes/rondes.dart';
import 'package:fempinya3_flutter_app/features/notifications/presentation/routes.dart';
import 'package:fempinya3_flutter_app/features/user_profile/presentation/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

GoRouter appRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    initialLocation: splashRoute,
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
