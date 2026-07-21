import 'package:equatable/equatable.dart';
import 'package:fempinya3_flutter_app/features/events/data/models/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/question.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/tag.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_status.dart';
import 'package:fempinya3_flutter_app/features/events/domain/enums/events_type.dart';
import 'package:intl/intl.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String dateHour;
  final String address;
  final EventStatusEnum status;
  final EventTypeEnum type;
  final String? description;
  final int? companions;
  final List<TagEntity>? tags;
  final String? comment;
  final List<QuestionEntity>? questions;

  const EventEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.dateHour,
    required this.address,
    required this.status,
    required this.type,
    required this.description,
    required this.companions,
    required this.tags,
    required this.comment,
    this.questions,
  });

  @override
  List<Object?> get props => [id, title, startDate, endDate, address, status, type, description, companions, tags, comment, questions];

  factory EventEntity.fromModel(EventModel model) {
    return EventEntity(
      id: model.id ?? 0,
      title: model.title ?? '',
      startDate: model.startDate ?? DateTime.now(),
      endDate: model.endDate ?? DateTime.now(),
      dateHour: DateFormat('H:mm').format(model.startDate ?? DateTime.now()),
      address: model.address ?? '',
      status: EventStatusEnumExtension.fromString(model.status ?? ""),
      type: EventTypeEnumExtension.fromString(model.type ?? ""),
      description: model.description ?? '',
      companions: model.companions ?? 0,
      tags: model.tags?.map((tag) => TagEntity.fromModel(tag)).toList() ?? [],
      comment: model.comment ?? '',
      questions: model.questions?.map((q) => QuestionEntity.fromModel(q)).toList(),
    );
  }

  EventModel toModel() {
    return EventModel(
      id: id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      address: address,
      status: status.name,
      type: type.name,
      description: description,
      companions: companions,
      tags: tags?.map((tag) => tag.toModel()).toList() ?? [],
      comment: comment,
    );
  }

  EventEntity copyWith({EventStatusEnum? status, int? companions, List<TagEntity>? tags, String? comment, List<QuestionEntity>? questions}) {
    return EventEntity(
      id: id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      dateHour: dateHour,
      address: address,
      status: status ?? this.status,
      type: type,
      description: description,
      companions: companions ?? this.companions,
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      questions: questions ?? this.questions,
    );
  }
}
