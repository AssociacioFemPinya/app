import 'package:dartz/dartz.dart';
import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/features/events/domain/repositories/events_repository.dart';

import 'package:femcastells/features/events/service_locator.dart';


class GetEventParams {
  final int? id;

  GetEventParams({
    this.id,
  });
}

class GetEvent implements UseCase<Either, GetEventParams> {
  final EventsRepository repository = sl<EventsRepository>();

  @override
  Future<Either> call({required GetEventParams params}) async {
    return await repository.getEvent(params);
  }
}
