import 'package:equatable/equatable.dart';
import 'package:femcastells/features/events/data/models/event.dart';
import 'package:femcastells/features/events/domain/entities/question.dart';
import 'package:femcastells/features/events/domain/entities/tag.dart';
import 'package:femcastells/features/events/domain/enums/events_status.dart';
import 'package:femcastells/features/events/domain/enums/events_type.dart';
import 'package:intl/intl.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? closeDate;
  final String dateHour;
  final String address;
  final EventStatusEnum status;
  final EventTypeEnum type;
  final String? description;
  final bool allowCompanions;
  final int? companions;
  final List<TagEntity>? tags;
  final String? comment;
  final List<QuestionEntity>? questions;

  const EventEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.closeDate,
    required this.dateHour,
    required this.address,
    required this.status,
    required this.type,
    required this.description,
    this.allowCompanions = true,
    required this.companions,
    required this.tags,
    required this.comment,
    this.questions,
  });

  bool get isClosed => closeDate != null && DateTime.now().isAfter(closeDate!);

  @override
  List<Object?> get props => [id, title, startDate, endDate, closeDate, address, status, type, description, allowCompanions, companions, tags, comment, questions];

  factory EventEntity.fromModel(EventModel model) {
    return EventEntity(
      id: model.id ?? 0,
      title: model.title ?? '',
      startDate: model.startDate ?? DateTime.now(),
      endDate: model.endDate ?? DateTime.now(),
      closeDate: model.closeDate,
      dateHour: DateFormat('H:mm').format(model.startDate ?? DateTime.now()),
      address: model.address ?? '',
      status: EventStatusEnumExtension.fromString(model.status ?? ""),
      type: EventTypeEnumExtension.fromString(model.type ?? ""),
      description: model.description ?? '',
      allowCompanions: model.allowCompanions ?? true,
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
      closeDate: closeDate,
      dateHour: dateHour,
      address: address,
      status: status ?? this.status,
      type: type,
      description: description,
      allowCompanions: allowCompanions,
      companions: companions ?? this.companions,
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      questions: questions ?? this.questions,
    );
  }
}
