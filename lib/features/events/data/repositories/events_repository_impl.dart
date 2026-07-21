import 'package:dartz/dartz.dart';
import 'package:fempinya3_flutter_app/features/events/data/sources/events_service.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/repositories/events_repository.dart';
import 'package:fempinya3_flutter_app/features/events/domain/useCases/get_event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/useCases/get_events_list.dart';

import 'package:fempinya3_flutter_app/features/events/service_locator.dart';

class EventsRepositoryImpl extends EventsRepository {
  @override
  Future<Either> getEventsList(GetEventsListParams params) async {
    return await sl<EventsService>().getEventsList(params);
  }
  @override
  Future<Either> getEvent(GetEventParams params) async {
    return await sl<EventsService>().getEvent(params);
  }
  @override
  Future<Either> postEvent(EventEntity params) async {
    return await sl<EventsService>().postEvent(params);
  }

  @override
  Future<Either> saveAnswers(int eventId, List<Map<String, dynamic>> answers) async {
    return await sl<EventsService>().saveAnswers(eventId, answers);
  }
}
