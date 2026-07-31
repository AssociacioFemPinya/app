import 'package:customizable_counter/customizable_counter.dart';
import 'package:fempinya3_flutter_app/core/utils/datetime_utils.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/event_view/event_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key, required this.eventID});
  final int eventID;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => EventViewBloc()..add(LoadEvent(eventID)),
        child: BlocBuilder<EventViewBloc, EventViewState>(
          builder: (context, state) {
            if (state is EventViewInitial || state.event == null) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            return _EventDetail(event: state.event!);
          },
        ),
      );
}

class _EventDetail extends StatelessWidget {
  const _EventDetail({required this.event});
  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    final canModify = event.registrationStatus == 'open';
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            _HeroCard(event: event),
            if (event.description?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              Text(event.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.45)),
            ],
            if (!canModify) ...[
              const SizedBox(height: 20),
              _RegistrationNotice(event: event),
            ],
            const SizedBox(height: 20),
            _SectionTitle(title: t.eventsPageAttendaceQuestion(event.title)),
            const SizedBox(height: 10),
            _AttendanceChoices(enabled: canModify),
            if (event.allowsCompanions) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: t.eventPageCompanionsSelector),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Icon(Icons.group_add_outlined,
                      color: colors.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(t.eventPageCompanionsSelector,
                          style: TextStyle(color: colors.onSurfaceVariant))),
                  BlocBuilder<EventViewBloc, EventViewState>(
                      builder: (context, state) => CustomizableCounter(
                            borderWidth: 0,
                            borderRadius: 24,
                            backgroundColor: colors.surface,
                            buttonText: '',
                            textColor: colors.onSurface,
                            textSize: 16,
                            count: (state.event?.companions ?? 0).toDouble(),
                            step: 1,
                            minCount: 0,
                            incrementIcon:
                                Icon(Icons.add, color: colors.primary),
                            decrementIcon:
                                Icon(Icons.remove, color: colors.primary),
                            onCountChange: canModify
                                ? (value) => context
                                    .read<EventViewBloc>()
                                    .add(EventCompanionsModified(value.toInt()))
                                : null,
                          )),
                ]),
              ),
            ],
            if (event.tags?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _SectionTitle(title: t.eventPageAdditionalOptionSelector),
              const SizedBox(height: 8),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: event.tags!
                      .map((tag) => FilterChip(
                            label: Text(tag.name),
                            selected: tag.isEnabled,
                            onSelected: canModify
                                ? (_) => context
                                    .read<EventViewBloc>()
                                    .add(EvenTagModified(tag.name))
                                : null,
                          ))
                      .toList()),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.event});
  final EventEntity event;
  @override
  Widget build(BuildContext context) {
    final color = _typeColor(event.type);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(_typeIcon(event.type), color: color, size: 18),
          const SizedBox(width: 6),
          Text(event.type.toLocalizedString(context),
              style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const Spacer(),
          _StatusPill(status: event.status)
        ]),
        const SizedBox(height: 12),
        Text(event.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        _Meta(
            icon: Icons.calendar_today_outlined,
            text: DateTimeUtils.formatDateToHumanLanguage(
                event.startDate, Localizations.localeOf(context).toString())),
        const SizedBox(height: 10),
        _Meta(icon: Icons.schedule_outlined, text: _timeRange(context)),
        if (event.address.isNotEmpty) ...[
          const SizedBox(height: 10),
          if (event.locationLink?.trim().isNotEmpty ?? false)
            InkWell(
              onTap: () => _openLocation(context, event.locationLink!),
              child: _Meta(
                  icon: Icons.location_on_outlined,
                  text: event.address,
                  color: Theme.of(context).colorScheme.primary),
            )
          else
            _Meta(icon: Icons.location_on_outlined, text: event.address)
        ],
      ]),
    );
  }

  String _timeRange(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final time = DateFormat.Hm(locale);
    if (DateUtils.isSameDay(event.startDate, event.endDate)) {
      return '${time.format(event.startDate)} – ${time.format(event.endDate)}';
    }
    return '${time.format(event.startDate)} – ${DateFormat('d MMM, HH:mm', locale).format(event.endDate)}';
  }

  Future<void> _openLocation(BuildContext context, String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No s’ha pogut obrir la ubicació')));
      }
    }
  }
}

class _AttendanceChoices extends StatelessWidget {
  const _AttendanceChoices({required this.enabled});
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      final current = state.event?.status;
      return Row(children: [
        _AttendanceButton(
            label: t.eventsPageAttendaceYesResponse,
            icon: Icons.check,
            color: const Color(0xFF247A4D),
            selected: current == EventStatusEnum.accepted,
            onTap:
                enabled ? () => _set(context, EventStatusEnum.accepted) : null),
        const SizedBox(width: 8),
        _AttendanceButton(
            label: t.eventsPageAttendaceNoResponse,
            icon: Icons.close,
            color: const Color(0xFFB42318),
            selected: current == EventStatusEnum.declined,
            onTap:
                enabled ? () => _set(context, EventStatusEnum.declined) : null),
        const SizedBox(width: 8),
        _AttendanceButton(
            label: t.eventsPageAttendaceUnknowResponse,
            icon: Icons.help_outline,
            color: const Color(0xFF9A6700),
            selected: current == EventStatusEnum.unknown,
            onTap:
                enabled ? () => _set(context, EventStatusEnum.unknown) : null),
      ]);
    });
  }

  void _set(BuildContext context, EventStatusEnum status) =>
      context.read<EventViewBloc>().add(EventStatusModified(status));
}

class _AttendanceButton extends StatelessWidget {
  const _AttendanceButton(
      {required this.label,
      required this.icon,
      required this.color,
      required this.selected,
      required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Expanded(
          child: Material(
        color: selected
            ? color.withValues(alpha: .12)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 72,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: selected
                          ? color
                          : Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(height: 4),
                    Text(label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.w700)),
                  ]),
            )),
      ));
}

class _RegistrationNotice extends StatelessWidget {
  const _RegistrationNotice({required this.event});
  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = event.registrationStatus == 'not_open_yet';
    final date =
        isUpcoming ? event.registrationOpenDate : event.registrationCloseDate;
    final formattedDate = date == null
        ? ''
        : DateFormat.yMMMd(Localizations.localeOf(context).toString())
            .add_jm()
            .format(date);
    final message = isUpcoming
        ? 'Les inscripcions s’obren $formattedDate'
        : 'Les inscripcions estan tancades${formattedDate.isEmpty ? '' : ' des de $formattedDate'}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(isUpcoming ? Icons.lock_clock_outlined : Icons.lock_outline),
        const SizedBox(width: 12),
        Expanded(
            child: Text(message,
                style: const TextStyle(fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700));
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, this.color});
  final IconData icon;
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon,
            size: 19,
            color: color ?? Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: color)))
      ]);
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final EventStatusEnum status;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final label = switch (status) {
      EventStatusEnum.accepted => t.eventsPageAttendaceYesResponse,
      EventStatusEnum.declined => t.eventsPageAttendaceNoResponse,
      EventStatusEnum.unknown => t.eventsPageAttendaceUnknowResponse,
      EventStatusEnum.undefined => t.eventsPageStatusFilterPending,
      EventStatusEnum.warning => t.eventsPageStatusFilterWarning
    };
    return Chip(label: Text(label), visualDensity: VisualDensity.compact);
  }
}

Color _typeColor(EventTypeEnum type) =>
    const {
      EventTypeEnum.training: Color(0xFF3F6FB5),
      EventTypeEnum.performance: Color(0xFF8B5E3C),
      EventTypeEnum.activity: Color(0xFF4C7A5A)
    }[type] ??
    const Color(0xFF4A5568);
IconData _typeIcon(EventTypeEnum type) =>
    const {
      EventTypeEnum.training: Icons.groups_outlined,
      EventTypeEnum.performance: Icons.campaign_outlined,
      EventTypeEnum.activity: Icons.auto_awesome_outlined
    }[type] ??
    Icons.event_outlined;
