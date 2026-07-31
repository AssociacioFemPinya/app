part of 'events_filters_bloc.dart';

enum EventsStatusFilters {
  missingReply,
  replied,
}

abstract class EventsFiltersEvent {}

class EventsStatusFilterUndefined extends EventsFiltersEvent {
  final bool value;
  EventsStatusFilterUndefined(this.value);
}

class EventsStatusFilterAnswered extends EventsFiltersEvent {
  final bool value;
  EventsStatusFilterAnswered(this.value);
}

class EventsTypeFiltersAdd extends EventsFiltersEvent {
  final EventTypeEnum value;
  EventsTypeFiltersAdd(this.value);
}

class EventsTypeFiltersRemove extends EventsFiltersEvent {
  final EventTypeEnum value;
  EventsTypeFiltersRemove(this.value);
}

class EventsDayFilterSet extends EventsFiltersEvent {
  final DateTime value;
  EventsDayFilterSet(this.value);
}

class EventsDayFilterUnset extends EventsFiltersEvent {
  EventsDayFilterUnset();
}
