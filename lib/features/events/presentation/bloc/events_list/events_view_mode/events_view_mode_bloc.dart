import 'package:femcastells/features/events/domain/enums/events_view_mode.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_view_mode_events.dart';
part 'events_view_mode_state.dart';

class EventsViewModeBloc
    extends Bloc<EventsViewModeEvent, EventsViewModeState> {
  EventsViewModeBloc()
      : super(EventsViewModeState(
          eventsViewMode: EventsViewModeEnum.list,
        )) {
    on<EventsViewModeSet>((event, emit) {
      emit(state.copyWith(eventsViewMode: event.value));
    });
  }
}
