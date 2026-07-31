part of 'events_filters_bloc.dart';

class EventsFiltersState extends Equatable {
  final bool showUndefined;
  final bool showAnswered;
  final List<EventTypeEnum> eventTypeFilters;
  final DateTime? dayFilter;
  final bool dayFilterEnabled;

  const EventsFiltersState(
      {required this.showUndefined,
      required this.showAnswered,
      required this.eventTypeFilters,
      required this.dayFilter,
      required this.dayFilterEnabled});

  EventsFiltersState copyWith({
    bool? showUndefined,
    bool? showAnswered,
    List<EventTypeEnum>? eventTypeFilters,
    DateTime? dayFilter,
    bool? dayFilterEnabled,
  }) {
    return EventsFiltersState(
        showUndefined: showUndefined ?? this.showUndefined,
        showAnswered: showAnswered ?? this.showAnswered,
        eventTypeFilters: eventTypeFilters ?? this.eventTypeFilters,
        dayFilter: dayFilter ?? this.dayFilter,
        dayFilterEnabled: dayFilterEnabled ?? this.dayFilterEnabled);
  }

  @override
  List<Object?> get props => [
        showUndefined,
        showAnswered,
        eventTypeFilters,
        dayFilter,
        dayFilterEnabled,
      ];
}
