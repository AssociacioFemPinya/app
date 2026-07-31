import 'package:dartz/dartz.dart';
import 'package:femcastells/features/events/domain/entities/event.dart';
import 'package:femcastells/features/events/domain/useCases/get_event.dart';
import 'package:femcastells/features/events/domain/useCases/get_events_list.dart';


abstract class EventsRepository {
  Future<Either> getEventsList(GetEventsListParams params);
  Future<Either> getEvent(GetEventParams params);
  Future<Either> postEvent(EventEntity params);
  Future<Either> saveAnswers(int eventId, List<Map<String, dynamic>> answers);
}
