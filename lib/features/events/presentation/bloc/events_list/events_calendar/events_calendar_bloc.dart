import 'package:femcastells/features/events/domain/useCases/get_events_list.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_events.dart';
import 'package:femcastells/features/events/presentation/bloc/events_list/events_calendar/events_calendar_state.dart';
import 'package:femcastells/features/events/service_locator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendarBloc
    extends Bloc<EventsCalendarEvent, EventsCalendarState> {
  EventsCalendarBloc()
      : super(EventsCalendarState(
          calendarEvents: {},
          calendarFormat: CalendarFormat.month,
          focusedDay: DateTime.now(),
          selectedDay: null,
        )) {
    on<EventsCalendarDateSelected>((event, emit) {
      emit(state.copyWith(selectedDay: event.value));
    });
    on<EventsCalendarDateSelectedUnset>((event, emit) {
      emit(state.copyWith(selectedDay: null));
    });
    on<EventsCalendarDateFocused>((event, emit) async {
      emit(state.copyWith(
          focusedDay: event.focusedDay, selectedDay: state.selectedDay));
    });
    on<EventsCalendarFormatSet>((event, emit) {
      emit(state.copyWith(
          calendarFormat: event.format, selectedDay: state.selectedDay));
    });
    on<LoadCalendarEvents>((events, emit) async {
      GetEventsListParams getEventsListParams = GetEventsListParams();
      var result = await sl<GetEventsList>().call(params: getEventsListParams);

      result.fold((failure) {
        add(CalendarEventsLoadFailure(failure));
      }, (data) {
        add(CalendarEventsLoadSuccess(data));
      });
    });
    on<CalendarEventsLoadSuccess>((events, emit) {
      final DateEventsName dateEvents = {};
      for (var event in events.value) {
        final eventDay = DateTime.utc(
            event.startDate.year, event.startDate.month, event.startDate.day);
        if (!dateEvents.containsKey(eventDay)) {
          dateEvents[eventDay] = [];
        }
        dateEvents[eventDay]!.add(event.title);
      }
      emit(state.copyWith(calendarEvents: dateEvents));
    });
    on<CalendarEventsLoadFailure>((errorMessage, emit) {
      // TODO
    });
  }
}
