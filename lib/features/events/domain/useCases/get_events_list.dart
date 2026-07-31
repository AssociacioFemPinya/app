import 'package:dartz/dartz.dart';
import 'package:fempinya3_flutter_app/core/usecase/usecase.dart';
import 'package:fempinya3_flutter_app/core/utils/datetime_utils.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:fempinya3_flutter_app/features/events/domain/repositories/events_repository.dart';

import 'package:fempinya3_flutter_app/features/events/service_locator.dart';

class GetEventsListParams {
  final List<EventTypeEnum> eventTypeFilters;
  final DateTimeRange? dayTimeRange;
  final bool showAnswered;
  final bool showUndefined;

  GetEventsListParams({
    this.eventTypeFilters = const [],
    this.dayTimeRange,
    this.showAnswered = false,
    this.showUndefined = false,
  });
}

class GetEventsList implements UseCase<Either, GetEventsListParams> {
  final EventsRepository repository = sl<EventsRepository>();

  @override
  Future<Either> call({required GetEventsListParams params}) async {
    return await repository.getEventsList(params);
  }
}
