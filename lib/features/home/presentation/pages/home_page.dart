import 'package:flutter/material.dart';
import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/useCases/get_events_list.dart';
import 'package:fempinya3_flutter_app/features/events/service_locator.dart'
    as events;
import 'package:fempinya3_flutter_app/features/menu/presentation/widgets/menu_widget.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/entities/notification.dart';
import 'package:fempinya3_flutter_app/features/notifications/domain/useCases/get_notifications.dart';
import 'package:fempinya3_flutter_app/features/notifications/service_locator.dart'
    as notifications;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Future<_HomeData> _data = _load();

  static Future<_HomeData> _load() async {
    final eventsResult =
        await events.sl<GetEventsList>()(params: GetEventsListParams());
    final notificationsResult = await notifications.sl<GetNotifications>()(
        params: GetNotificationsParams());
    return _HomeData(
      eventsResult.fold(
          (_) => <EventEntity>[], (data) => data as List<EventEntity>),
      notificationsResult.fold((_) => <NotificationEntity>[],
          (data) => data as List<NotificationEntity>),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.menuHome)),
        drawer: const MenuWidget(),
        body: FutureBuilder<_HomeData>(
          future: _data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            final confirmed = data.events
                .where((e) => e.status == EventStatusEnum.accepted)
                .take(3)
                .toList();
            final unread =
                data.notifications.where((n) => !n.isRead).take(3).toList();
            return ListView(padding: const EdgeInsets.all(16), children: [
              Text('Bon dia',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              _Card(
                  title: 'Pròxims esdeveniments on hi aniràs',
                  icon: Icons.event_available_outlined,
                  child: confirmed.isEmpty
                      ? const Text('Encara no has confirmat cap esdeveniment.')
                      : Column(
                          children: confirmed
                              .map((e) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(e.title),
                                  subtitle: Text(
                                      '${e.startDate.day}/${e.startDate.month} · ${e.dateHour}'),
                                  onTap: () => context.pushNamed(eventRoute,
                                          pathParameters: {
                                            'eventID': e.id.toString()
                                          })))
                              .toList())),
              const SizedBox(height: 16),
              _Card(
                  title: 'Notificacions',
                  icon: Icons.notifications_none,
                  child: unread.isEmpty
                      ? const Text('No tens notificacions sense llegir.')
                      : Column(
                          children: unread
                              .map((n) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(n.title),
                                  subtitle: Text(n.message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)))
                              .toList())),
              const SizedBox(height: 16),
              _Card(
                  title: 'La teva assistència',
                  icon: Icons.insights_outlined,
                  child: Row(children: [
                    _Stat(
                        data.events
                            .where((e) => e.status == EventStatusEnum.accepted)
                            .length,
                        'Sí'),
                    _Stat(
                        data.events
                            .where((e) => e.status == EventStatusEnum.declined)
                            .length,
                        'No'),
                    _Stat(
                        data.events
                            .where((e) =>
                                e.status == EventStatusEnum.undefined ||
                                e.status == EventStatusEnum.unknown)
                            .length,
                        'Pendents'),
                  ])),
            ]);
          },
        ),
      );
}

class _HomeData {
  const _HomeData(this.events, this.notifications);
  final List<EventEntity> events;
  final List<NotificationEntity> notifications;
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.icon, required this.child});
  final String title;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700))
        ]),
        const SizedBox(height: 10),
        child
      ]));
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final int value;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
          child: Column(children: [
        Text('$value',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        Text(label)
      ]));
}
