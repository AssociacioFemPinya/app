part of 'event_view_bloc.dart';

abstract class EventViewEvent {}

class LoadEvent extends EventViewEvent {
  final int value;
  LoadEvent(this.value);
}

class EventLoadSuccess extends EventViewEvent {
  final EventEntity value;
  EventLoadSuccess(this.value);
}

class EventLoadFailure extends EventViewEvent {
  final String value;
  EventLoadFailure(this.value);
}

class EventStatusModified extends EventViewEvent {
  final EventStatusEnum value;
  EventStatusModified(this.value);
}

class EventCompanionsModified extends EventViewEvent {
  final int value;
  EventCompanionsModified(this.value);
}

class EvenTagModified extends EventViewEvent {
  final String value;
  EvenTagModified(this.value);
}

class UpdateEvent extends EventViewEvent {
  final EventEntity value;
  UpdateEvent(this.value);
}

class EventUpdateSuccess extends EventViewEvent {
  final EventEntity value;
  EventUpdateSuccess(this.value);
}

class EventUpdateFailure extends EventViewEvent {
  final String value;
  EventUpdateFailure(this.value);
}
