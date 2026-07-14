import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

class EventsFiltersButton extends StatelessWidget {
  const EventsFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Align(
        //alignment: Alignment.centerRight,
        child: buildFilterButton(context),
      ),
    );
  }

    /// Builds a filter button with a dropdown menu
    Widget buildFilterButton(BuildContext context) {
      final translate = AppLocalizations.of(context)!;

      return BlocBuilder<EventsFiltersBloc, EventsFiltersState>(
        builder: (context, state) {
      return Material(
        color: Theme.of(context).colorScheme.primaryFixed,
        elevation: 0,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        ),
        child: PopupMenuButton<EventTypeEnum>(
        color: Theme.of(context).colorScheme.primaryFixed,
        shadowColor: Theme.of(context).colorScheme.primaryFixed, 
        onSelected: (EventTypeEnum value) {
          context.read<EventsFiltersBloc>().add(EventsTypeFiltersAdd(value));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
            translate.eventsPageTypeFilterTitle,
            style:
              TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 3),
            Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
            ),
          ],
          ),
        ),
        itemBuilder: (BuildContext context) {
          return [
          for (var item in EventTypeEnum.values)
          PopupMenuItem<EventTypeEnum>(
            value: item,
            child: Text(
            item.toLocalizedString(context),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryFixedVariant), 
            ),
          ),
          ];
        },
        ),
      );
      });
    }
  }
