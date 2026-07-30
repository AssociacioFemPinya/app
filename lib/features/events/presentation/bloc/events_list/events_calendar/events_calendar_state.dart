import 'package:table_calendar/table_calendar.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';

typedef DateEvents = Map<DateTime, List<EventEntity>>;

class EventsCalendarState {
  final DateEvents calendarEvents;
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime? selectedDay;

  EventsCalendarState(
      {required this.calendarEvents,
      required this.calendarFormat,
      required this.focusedDay,
      required this.selectedDay});

  EventsCalendarState copyWith({
    DateEvents? calendarEvents,
    CalendarFormat? calendarFormat,
    DateTime? focusedDay,
    DateTime? selectedDay,
  }) {
    return EventsCalendarState(
      calendarEvents: calendarEvents ?? this.calendarEvents,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay,
    );
  }
}
