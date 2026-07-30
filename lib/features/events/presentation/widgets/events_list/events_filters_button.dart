import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/events_list/events_filters/events_filters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventsFiltersButton extends StatelessWidget {
  const EventsFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<EventTypeEnum>(
      tooltip: translate.eventsPageTypeFilterTitle,
      color: colorScheme.surface,
      position: PopupMenuPosition.under,
      onSelected: (value) =>
          context.read<EventsFiltersBloc>().add(EventsTypeFiltersAdd(value)),
      itemBuilder: (context) => [
        for (final type in EventTypeEnum.values)
          PopupMenuItem(
            value: type,
            child: Text(type.toLocalizedString(context)),
          ),
      ],
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          color: colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.tune_outlined, size: 16),
              const SizedBox(width: 4),
              Text(
                translate.eventsPageTypeFilterTitle,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.add, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
