import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventsStatusFiltersWidget extends StatelessWidget {
  const EventsStatusFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
      builder: (context, state) {
        return Wrap(
          spacing: 6,
          runSpacing: 8,
          children: [
            _StatusFilter(
              label: translate.eventsPageStatusFilterPending,
              selected: state.showUndefined,
              onSelected: (value) => context
                  .read<EventsFiltersBloc>()
                  .add(EventsStatusFilterUndefined(value)),
            ),
            _StatusFilter(
              label: translate.eventsPageStatusFilterAnswered,
              selected: state.showAnswered,
              onSelected: (value) => context
                  .read<EventsFiltersBloc>()
                  .add(EventsStatusFilterAnswered(value)),
            ),
            _StatusFilter(
              label: translate.eventsPageStatusFilterWarning,
              selected: state.showWarning,
              onSelected: (value) => context
                  .read<EventsFiltersBloc>()
                  .add(EventsStatusFilterWarning(value)),
            ),
          ],
        );
      },
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: onSelected,
      side: BorderSide(color: colorScheme.outlineVariant),
      selectedColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
