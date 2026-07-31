import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/login/login.dart';

import 'package:go_router/go_router.dart';

final List<GoRoute> loginRoutes = [
  GoRoute(
    name: splashRoute,
    path: splashRoute,
    builder: (context, state) {
      return const SplashPage();
    },
  ),
  GoRoute(
    name: loginRoute,
    path: loginRoute,
    builder: (context, state) {
      return const LoginPage();
    },
  ),
];
