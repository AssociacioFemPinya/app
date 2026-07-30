import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_events.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_state.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends StatelessWidget {
  const EventsCalendar({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EventsViewModeBloc, EventsViewModeState>(
        builder: (context, viewState) {
          if (!viewState.isEventInViewModeCalendar()) {
            return const SizedBox.shrink();
          }
          return Expanded(child: _calendarContent(context));
        },
      );

  Widget _calendarContent(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<EventsCalendarBloc, EventsCalendarState>(
      builder: (context, state) =>
          BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
        builder: (context, _) {
          final visibleEvents = state.calendarEvents;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.outlineVariant)),
                child: Column(children: [
                  TableCalendar<EventEntity>(
                    rowHeight: 38,
                    daysOfWeekHeight: 22,
                    firstDay: DateTime.utc(2010, 1, 1),
                    lastDay: DateTime.utc(2035, 12, 31),
                    focusedDay: state.focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(state.selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: locale,
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        headerPadding: const EdgeInsets.symmetric(vertical: 2),
                        leftChevronMargin: EdgeInsets.zero,
                        rightChevronMargin: EdgeInsets.zero,
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w700)),
                    calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                            color: colors.primary, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                            border:
                                Border.all(color: colors.primary, width: 1.5),
                            shape: BoxShape.circle),
                        todayTextStyle: TextStyle(color: colors.primary)),
                    eventLoader: (day) => visibleEvents[_dayKey(day)] ?? [],
                    onDaySelected: (selected, focused) {
                      context.read<EventsCalendarBloc>()
                        ..add(EventsCalendarDateSelected(selected))
                        ..add(EventsCalendarDateFocused(focused));
                      context
                          .read<EventsFiltersBloc>()
                          .add(EventsDayFilterSet(selected));
                    },
                    onPageChanged: (focused) => context
                        .read<EventsCalendarBloc>()
                        .add(EventsCalendarDateFocused(focused)),
                    calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) =>
                            _markers(events)),
                  ),
                  const Divider(height: 12),
                  _legend(context)
                ]),
              ),
              const SizedBox(height: 8),
              Expanded(child: _dayAgenda(context, state, visibleEvents)),
            ],
          );
        },
      ),
    );
  }

  Widget _markers(List<EventEntity> events) {
    if (events.isEmpty) return const SizedBox.shrink();
    return Positioned(
        bottom: 3,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: events
                .take(3)
                .map((event) => Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                        color: _typeColor(event.type), shape: BoxShape.circle)))
                .toList()));
  }

  Widget _dayAgenda(BuildContext context, EventsCalendarState state,
      DateEvents visibleEvents) {
    final selected = state.selectedDay;
    if (selected == null) return const SizedBox.shrink();
    final events = visibleEvents[_dayKey(selected)] ?? [];
    final translate = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          DateFormat('EEEE, d MMMM', Localizations.localeOf(context).toString())
              .format(selected),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      if (events.isEmpty)
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(translate.eventsPageCalendarEmpty,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)))
      else
        Expanded(
            child: ListView.separated(
                itemCount: events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _agendaItem(context, events[index]))),
    ]);
  }

  Widget _agendaItem(BuildContext context, EventEntity event) => InkWell(
        onTap: () => context.pushNamed(eventRoute,
            pathParameters: {'eventID': event.id.toString()}),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: Row(children: [
              SizedBox(
                  width: 54,
                  child: Text(event.dateHour,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _typeColor(event.type),
                          fontWeight: FontWeight.w700))),
              Container(width: 3, height: 34, color: _typeColor(event.type)),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(event.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(_statusText(context, event.status),
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12))
                  ])),
              const Icon(Icons.chevron_right),
            ])),
      );

  DateTime _dayKey(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);

  Widget _legend(BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: EventTypeEnum.values
            .map((type) => Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_typeIcon(type), size: 14, color: _typeColor(type)),
                  const SizedBox(width: 4),
                  Text(type.toLocalizedString(context),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _typeColor(type),
                          fontWeight: FontWeight.w600)),
                ]))
            .toList(),
      );

  IconData _typeIcon(EventTypeEnum type) =>
      const {
        EventTypeEnum.training: Icons.groups_outlined,
        EventTypeEnum.performance: Icons.campaign_outlined,
        EventTypeEnum.activity: Icons.auto_awesome_outlined
      }[type] ??
      Icons.event_outlined;
  Color _typeColor(EventTypeEnum type) =>
      const {
        EventTypeEnum.training: Color(0xFF3F6FB5),
        EventTypeEnum.performance: Color(0xFF8B5E3C),
        EventTypeEnum.activity: Color(0xFF4C7A5A)
      }[type] ??
      const Color(0xFF4A5568);
  String _statusText(BuildContext context, EventStatusEnum status) {
    final t = AppLocalizations.of(context)!;
    return switch (status) {
      EventStatusEnum.accepted => t.eventsPageAttendaceYesResponse,
      EventStatusEnum.declined => t.eventsPageAttendaceNoResponse,
      EventStatusEnum.unknown => t.eventsPageAttendaceUnknowResponse,
      EventStatusEnum.undefined => t.eventsPageStatusFilterPending,
      EventStatusEnum.warning => t.eventsPageStatusFilterWarning
    };
  }
}
