import 'package:equatable/equatable.dart';
import 'package:femcastells/features/events/domain/enums/events_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_filters_state.dart';
part 'events_filters_events.dart';

class EventsFiltersBloc extends Bloc<EventsFiltersEvent, EventsFiltersState> {
  EventsFiltersBloc()
      : super(const EventsFiltersState(
          // TODO: See if we can merge all those three state in a single one for the filter buttons
          showUndefined: false,
          showAnswered: false,
          showWarning: false,
          eventTypeFilters: [],
          dayFilter: null,
          dayFilterEnabled: false,
        )) {
    on<EventsStatusFilterUndefined>((event, emit) {
      emit(state.copyWith(
          showUndefined: event.value, showAnswered: false, showWarning: false));
    });
    on<EventsStatusFilterAnswered>((event, emit) {
      emit(state.copyWith(
          showUndefined: false, showAnswered: event.value, showWarning: false));
    });
    on<EventsStatusFilterWarning>((event, emit) {
      emit(state.copyWith(
          showUndefined: false, showAnswered: false, showWarning: event.value));
    });
    on<EventsTypeFiltersAdd>((event, emit) {
      if (!state.eventTypeFilters.contains(event.value)) {
        emit(state.copyWith(
            eventTypeFilters: List.from(state.eventTypeFilters)
              ..add(event.value)));
      }
    });
    on<EventsTypeFiltersRemove>((event, emit) {
      if (state.eventTypeFilters.contains(event.value)) {
        emit(state.copyWith(
            eventTypeFilters: List.from(state.eventTypeFilters)
              ..remove(event.value)));
      }
    });
    on<EventsDayFilterSet>((event, emit) {
      emit(state.copyWith(dayFilter: event.value, dayFilterEnabled: true));
    });
    on<EventsDayFilterUnset>((event, emit) {
      emit(state.copyWith(dayFilterEnabled: false));
    });
  }
}
