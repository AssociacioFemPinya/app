import 'package:femcastells/features/events/domain/enums/events_type.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsFiltersInputChipsWidget extends StatelessWidget {
  const EventsFiltersInputChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Wrap(
          spacing: 8.0,
          children: <Widget>[
            for (var item in state.eventTypeFilters)
              InputChip(
                label: Text(
                  item.toLocalizedString(context),
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryFixedVariant),
                ),
                onDeleted: () {
                  context
                      .read<EventsFiltersBloc>()
                      .add(EventsTypeFiltersRemove(item));
                },
                selectedColor: Theme.of(context).colorScheme.primaryFixed,
                checkmarkColor: Theme.of(context).colorScheme.primaryFixed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(style: BorderStyle.none)),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryFixedDim
                    .withOpacity(0.3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
          ],
        ),
      );
    });
  }
}
