import 'package:dartz/dartz.dart';
import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/core/utils/datetime_utils.dart';
import 'package:femcastells/features/events/domain/enums/events_type.dart';
import 'package:femcastells/features/events/domain/repositories/events_repository.dart';

import 'package:femcastells/features/events/service_locator.dart';


class GetEventsListParams {
  final List<EventTypeEnum> eventTypeFilters;
  final DateTimeRange? dayTimeRange;
  final bool showAnswered;
  final bool showUndefined;
  final bool showWarning;

  GetEventsListParams({
    this.eventTypeFilters = const [],
    this.dayTimeRange,
    this.showAnswered = false,
    this.showUndefined = false,
    this.showWarning = false,
  });
}

class GetEventsList implements UseCase<Either, GetEventsListParams> {
  final EventsRepository repository = sl<EventsRepository>();

  @override
  Future<Either> call({required GetEventsListParams params}) async {
    return await repository.getEventsList(params);
  }
}
