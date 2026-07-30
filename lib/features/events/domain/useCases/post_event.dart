import 'package:dartz/dartz.dart';
import 'package:femcastells/core/usecase/usecase.dart';
import 'package:femcastells/features/events/domain/entities/event.dart';
import 'package:femcastells/features/events/domain/repositories/events_repository.dart';

import 'package:femcastells/features/events/service_locator.dart';


class PostEvent implements UseCase<Either, EventEntity> {
  final EventsRepository repository = sl<EventsRepository>();

  @override
  Future<Either> call({required EventEntity params}) async {
    return await repository.postEvent(params);
  }
}
