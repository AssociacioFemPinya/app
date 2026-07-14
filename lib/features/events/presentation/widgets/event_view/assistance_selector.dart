import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/presentation/bloc/event_view/event_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

class AssistanceSelector extends StatelessWidget {
  const AssistanceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<EventViewBloc, EventViewState>(
        builder: (context, state) {
      return SegmentedButton<EventStatusEnum>(
        segments:  <ButtonSegment<EventStatusEnum>>[
          ButtonSegment<EventStatusEnum>(
            value: EventStatusEnum.accepted,
            label: Text(translate.eventsPageAttendaceYesResponse),
          ),
          ButtonSegment<EventStatusEnum>(
            value: EventStatusEnum.declined,
            label: Text(translate.eventsPageAttendaceNoResponse),
          ),
          ButtonSegment<EventStatusEnum>(
            value: EventStatusEnum.unknown,
            label: Text(translate.eventsPageAttendaceUnknowResponse),
          ),
        ],
        selected: state.event?.status != EventStatusEnum.undefined ? <EventStatusEnum>{state.event!.status} : {},
        emptySelectionAllowed: true,
        onSelectionChanged: (Set<EventStatusEnum> newSelection) {
          context.read<EventViewBloc>().add(EventStatusModified(newSelection.first));
        },
        style: ButtonStyle(
          side: WidgetStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.primaryFixedDim)),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primaryFixedDim; 
              }
              return null; 
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(context).colorScheme.primaryFixed;
              }
              return null;
            },
          ),
        ),
      );
    });
  }
}
