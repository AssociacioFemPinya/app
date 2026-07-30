import 'package:fempinya3_flutter_app/features/events/domain/enums/events_view_mode.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_events.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsViewModeWidget extends StatelessWidget {
  const EventsViewModeWidget({super.key});

  void _setViewMode(BuildContext context, EventsViewModeEnum viewMode) {
    context.read<EventsViewModeBloc>().add(EventsViewModeSet(viewMode));
    if (viewMode == EventsViewModeEnum.list) {
      context.read<EventsFiltersBloc>().add(EventsDayFilterUnset());
      return;
    }

    context.read<EventsCalendarBloc>().add(LoadCalendarEvents());
    context.read<EventsCalendarBloc>().add(EventsCalendarDateSelectedUnset());
    context
        .read<EventsCalendarBloc>()
        .add(EventsCalendarFormatSet(CalendarFormat.month));
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<EventsViewModeBloc, EventsViewModeState>(
      builder: (context, state) {
        return Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _ViewModeOption(
                label: translate.eventsPageEventViewModeList,
                icon: Icons.format_list_bulleted_outlined,
                selected: state.eventsViewMode == EventsViewModeEnum.list,
                onTap: () => _setViewMode(context, EventsViewModeEnum.list),
              ),
              _ViewModeOption(
                label: translate.eventsPageEventViewModeCalendar,
                icon: Icons.calendar_month_outlined,
                selected: state.eventsViewMode == EventsViewModeEnum.calendar,
                onTap: () => _setViewMode(context, EventsViewModeEnum.calendar),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModeOption extends StatelessWidget {
  const _ViewModeOption(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Material(
        color: selected ? colorScheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 19,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant),
              const SizedBox(width: 7),
              Text(label,
                  style: TextStyle(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
