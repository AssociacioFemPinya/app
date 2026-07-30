import 'package:femcastells/core/navigation/route_names.dart';
import 'package:go_router/go_router.dart';

import 'presentation.dart';

final List<GoRoute> userProfileRoutes = [
  GoRoute(
    name: userProfileRoute,
    path: userProfileRoute,
    builder: (context, state) => const UserProfilePage(),
  ),
];
