import 'package:fempinya3_flutter_app/core/utils/datetime_utils.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/core/navigation/route_names.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_view_mode.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_list/events_list_bloc.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_view_mode/events_view_mode_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EventsListWidget extends StatelessWidget {
  const EventsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsViewMode =
        context.watch<EventsViewModeBloc>().state.eventsViewMode;

    if (eventsViewMode == EventsViewModeEnum.calendar) {
      return const SizedBox.shrink();
    }
    return Expanded(child: _listView());
  }

  Widget _listView() {
    return BlocBuilder<EventsListBloc, EventsListState>(
      builder: (context, state) {
        final sortedDates = state.events.keys.toList()..sort();
        if (sortedDates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: sortedDates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final events = state.events[date] ?? [];
            return _buildDateEventsList(date, events, context);
          },
        );
      },
    );
  }

  Widget _buildDateEventsList(
      DateTime date, List<EventEntity> events, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(date, context),
        const SizedBox(height: 8),
        ...events.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildEventCard(event, context),
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeader(DateTime date, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              DateTimeUtils.formatDateToHumanLanguage(
                  date, Localizations.localeOf(context).toString()),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventEntity event, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final translate = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        final eventsListBloc = context.read<EventsListBloc>();
        final eventsFiltersBloc = context.read<EventsFiltersBloc>();
        context.pushNamed(
          eventRoute,
          pathParameters: {'eventID': event.id.toString()},
        ).then((_) {
          eventsListBloc.add(LoadEventsList(eventsFiltersBloc.state));
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBadge(date: event.startDate, color: _typeColor(event.type)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _InfoPill(
                          icon: _typeIcon(event.type),
                          label: event.type.toLocalizedString(context),
                          color: _typeColor(event.type),
                        ),
                        _AttendancePill(
                          status: event.status,
                          label: _statusLabel(event.status, translate),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _EventMeta(
                      icon: Icons.schedule_outlined,
                      text: event.dateHour,
                    ),
                    if (event.address.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      _EventMeta(
                        icon: Icons.location_on_outlined,
                        text: event.address,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(EventTypeEnum type) =>
      const {
        EventTypeEnum.training: Icons.groups_outlined,
        EventTypeEnum.performance: Icons.campaign_outlined,
        EventTypeEnum.activity: Icons.auto_awesome_outlined,
      }[type] ??
      Icons.event_outlined;

  Color _typeColor(EventTypeEnum type) =>
      const {
        EventTypeEnum.training: Color(0xFF3F6FB5),
        EventTypeEnum.performance: Color(0xFF8B5E3C),
        EventTypeEnum.activity: Color(0xFF4C7A5A),
      }[type] ??
      const Color(0xFF4A5568);

  String _statusLabel(EventStatusEnum status, AppLocalizations translate) =>
      switch (status) {
        EventStatusEnum.accepted => translate.eventsPageAttendaceYesResponse,
        EventStatusEnum.declined => translate.eventsPageAttendaceNoResponse,
        EventStatusEnum.unknown => translate.eventsPageAttendaceUnknowResponse,
        EventStatusEnum.undefined => translate.eventsPageStatusFilterPending,
        EventStatusEnum.warning => translate.eventsPageStatusFilterWarning,
      };
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date, required this.color});

  final DateTime date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE', locale).format(date).toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${date.day}',
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            DateFormat('MMM', locale).format(date).toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendancePill extends StatelessWidget {
  const _AttendancePill({required this.status, required this.label});

  final EventStatusEnum status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      EventStatusEnum.accepted => (
          const Color(0xFF247A4D),
          Icons.check_circle_outline
        ),
      EventStatusEnum.declined => (
          const Color(0xFFB42318),
          Icons.cancel_outlined
        ),
      EventStatusEnum.unknown => (const Color(0xFF9A6700), Icons.help_outline),
      EventStatusEnum.undefined => (
          const Color(0xFF5D6775),
          Icons.pending_outlined
        ),
      EventStatusEnum.warning => (
          const Color(0xFFB54708),
          Icons.warning_amber_outlined
        ),
    };

    return _InfoPill(icon: icon, label: label, color: color);
  }
}

class _EventMeta extends StatelessWidget {
  const _EventMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ],
    );
  }
}
