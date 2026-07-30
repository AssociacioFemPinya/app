import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_view_mode.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_calendar/events_calendar_events.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsToolbar extends StatelessWidget {
  const EventsToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCalendar =
        context.watch<EventsViewModeBloc>().state.isEventInViewModeCalendar();
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
              builder: (context, state) => InkWell(
                onTap: () {
                  if (isCalendar) {
                    final today = DateTime.now();
                    context.read<EventsCalendarBloc>()
                      ..add(EventsCalendarDateSelected(today))
                      ..add(EventsCalendarDateFocused(today));
                  } else {
                    _showFilters(context);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                          isCalendar
                              ? Icons.today_outlined
                              : Icons.tune_outlined,
                          size: 19,
                          color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isCalendar
                              ? AppLocalizations.of(context)!
                                  .eventsPageCalendarToday
                              : _filterSummary(context, state),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      if (!isCalendar)
                        Icon(Icons.expand_more,
                            size: 20, color: colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _ViewButton(
            mode: EventsViewModeEnum.list,
            icon: Icons.format_list_bulleted_outlined,
            tooltip: AppLocalizations.of(context)!.eventsPageEventViewModeList,
          ),
          _ViewButton(
            mode: EventsViewModeEnum.calendar,
            icon: Icons.calendar_month_outlined,
            tooltip:
                AppLocalizations.of(context)!.eventsPageEventViewModeCalendar,
          ),
        ],
      ),
    );
  }

  String _filterSummary(BuildContext context, EventsFiltersState state) {
    final translate = AppLocalizations.of(context)!;
    final labels = <String>[];
    if (state.showUndefined) {
      labels.add(translate.eventsPageStatusFilterPending);
    }
    if (state.showAnswered) {
      labels.add(translate.eventsPageStatusFilterAnswered);
    }
    if (state.showWarning) {
      labels.add(translate.eventsPageStatusFilterWarning);
    }
    labels.addAll(
        state.eventTypeFilters.map((type) => type.toLocalizedString(context)));
    return labels.isEmpty ? translate.eventsPageFilterAll : labels.join(' · ');
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<EventsFiltersBloc>(),
        child: const _EventsFiltersSheet(),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton(
      {required this.mode, required this.icon, required this.tooltip});

  final EventsViewModeEnum mode;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<EventsViewModeBloc, EventsViewModeState>(
      builder: (context, state) {
        final selected = state.eventsViewMode == mode;
        return Tooltip(
          message: tooltip,
          child: Material(
            color: selected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => _setViewMode(context),
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(icon,
                    size: 21,
                    color: selected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        );
      },
    );
  }

  void _setViewMode(BuildContext context) {
    context.read<EventsViewModeBloc>().add(EventsViewModeSet(mode));
    if (mode == EventsViewModeEnum.list) {
      context.read<EventsFiltersBloc>().add(EventsDayFilterUnset());
      return;
    }
    context.read<EventsCalendarBloc>().add(LoadCalendarEvents());
    context.read<EventsCalendarBloc>().add(EventsCalendarDateSelectedUnset());
    context
        .read<EventsCalendarBloc>()
        .add(EventsCalendarFormatSet(CalendarFormat.month));
  }
}

class _EventsFiltersSheet extends StatelessWidget {
  const _EventsFiltersSheet();

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(translate.eventsPageFilterSheetTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                ),
                TextButton(
                  onPressed: () => _clearFilters(context, state),
                  child: Text(translate.eventsPageFilterClear),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(translate.eventsPageFilterStatusTitle,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(translate.eventsPageFilterAll),
                  selected: !state.showUndefined &&
                      !state.showAnswered &&
                      !state.showWarning,
                  onSelected: (_) => _clearStatus(context),
                ),
                _statusChip(
                    context,
                    state.showUndefined,
                    translate.eventsPageStatusFilterPending,
                    EventsStatusFilterUndefined.new),
                _statusChip(
                    context,
                    state.showAnswered,
                    translate.eventsPageStatusFilterAnswered,
                    EventsStatusFilterAnswered.new),
                _statusChip(
                    context,
                    state.showWarning,
                    translate.eventsPageStatusFilterWarning,
                    EventsStatusFilterWarning.new),
              ],
            ),
            const SizedBox(height: 22),
            Text(translate.eventsPageFilterTypeTitle,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in EventTypeEnum.values)
                  FilterChip(
                    label: Text(type.toLocalizedString(context)),
                    selected: state.eventTypeFilters.contains(type),
                    onSelected: (selected) =>
                        context.read<EventsFiltersBloc>().add(
                              selected
                                  ? EventsTypeFiltersAdd(type)
                                  : EventsTypeFiltersRemove(type),
                            ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, bool selected, String label,
      EventsFiltersEvent Function(bool) createEvent) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) =>
          context.read<EventsFiltersBloc>().add(createEvent(value)),
    );
  }

  void _clearStatus(BuildContext context) {
    final bloc = context.read<EventsFiltersBloc>();
    bloc
      ..add(EventsStatusFilterUndefined(false))
      ..add(EventsStatusFilterAnswered(false))
      ..add(EventsStatusFilterWarning(false));
  }

  void _clearFilters(BuildContext context, EventsFiltersState state) {
    _clearStatus(context);
    final bloc = context.read<EventsFiltersBloc>();
    for (final type in state.eventTypeFilters) {
      bloc.add(EventsTypeFiltersRemove(type));
    }
  }
}
