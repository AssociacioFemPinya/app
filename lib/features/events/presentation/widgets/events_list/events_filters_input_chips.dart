import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsFiltersInputChipsWidget extends StatelessWidget {
  const EventsFiltersInputChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
      builder: (context, state) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final type in state.eventTypeFilters)
            InputChip(
              label: Text(type.toLocalizedString(context)),
              avatar: const Icon(Icons.label_outline, size: 16),
              onDeleted: () => context
                  .read<EventsFiltersBloc>()
                  .add(EventsTypeFiltersRemove(type)),
              deleteIcon: const Icon(Icons.close, size: 18),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
        ],
      ),
    );
  }
}
