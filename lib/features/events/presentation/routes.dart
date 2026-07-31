import 'package:femcastells/features/events/presentation/pages/event_view/event_page.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/events/presentation/pages/events_list/events_list_page.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> eventRoutes = [
  GoRoute(
    name: eventsRoute,
    path: eventsRoute,
    builder: (context, state) => const EventsListPage(),
  ),
  GoRoute(
    name: eventRoute,
    path: '$eventRoute/:eventID',
    builder: (context, state) {
      final eventID = int.parse(state.pathParameters['eventID']!);
      return EventPage(eventID: eventID);
    },
  ),
];
