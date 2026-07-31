import 'package:femcastells/features/events/domain/entities/event.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class EventsCalendarEvent {}

class EventsCalendarDateSelected extends EventsCalendarEvent {
  final DateTime value;
  EventsCalendarDateSelected(this.value);
}

class EventsCalendarDateSelectedUnset extends EventsCalendarEvent {
  EventsCalendarDateSelectedUnset();
}

class EventsCalendarDateFocused extends EventsCalendarEvent {
  final DateTime focusedDay;
  EventsCalendarDateFocused(this.focusedDay);
}

class EventsCalendarFormatSet extends EventsCalendarEvent {
  final CalendarFormat format;
  EventsCalendarFormatSet(this.format);
}

class LoadCalendarEvents extends EventsCalendarEvent {}

class CalendarEventsLoadSuccess extends EventsCalendarEvent {
  final List<EventEntity> value;
  CalendarEventsLoadSuccess(this.value);
}

class CalendarEventsLoadFailure extends EventsCalendarEvent {
  final String value;
  CalendarEventsLoadFailure(this.value);
}
