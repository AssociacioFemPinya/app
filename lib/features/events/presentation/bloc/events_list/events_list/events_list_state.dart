part of 'events_list_bloc.dart';

typedef DateEvents = Map<DateTime, List<EventEntity>>;

class EventsListState {
  final DateEvents events;
  final bool isLoading;
  final String? errorMessage;

  EventsListState({
    required this.events,
    this.isLoading = true,
    this.errorMessage,
  });

  EventsListState copyWith({
    DateEvents? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventsListState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
