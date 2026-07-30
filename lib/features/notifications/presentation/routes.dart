import 'package:go_router/go_router.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/notifications/presentation/pages/notifications_page.dart';

final List<GoRoute> notificationRoutes = [
  GoRoute(
    name: notificationsRoute,
    path: notificationsRoute,
    builder: (context, state) => const NotificationsPage(),
  ),
];
