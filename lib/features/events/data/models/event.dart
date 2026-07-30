import 'package:femcastells/features/events/data/models/question.dart';
import 'package:femcastells/features/events/data/models/tag.dart';

class EventModel {
  final int? id;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? closeDate;
  final String? address;
  final String? status;
  final String? type;
  final String? description;
  final bool? allowCompanions;
  final int? companions;
  final List<TagModel>? tags;
  final String? comment;
  final List<QuestionModel>? questions;

  EventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.closeDate,
    required this.address,
    required this.status,
    required this.type,
    required this.description,
    this.allowCompanions,
    required this.companions,
    required this.tags,
    required this.comment,
    this.questions,
  });

  // Factory constructor for JSON deserialization
  factory EventModel.fromJson(Map<String, dynamic> data) {
    var tagsFromJson = data['tags'] as List?;
    List<TagModel>? tagList = tagsFromJson?.map((tag) => TagModel.fromJson(tag)).toList();

    var questionsFromJson = data['questions'] as List?;
    List<QuestionModel>? questionList = questionsFromJson
        ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();

    return EventModel(
      id: data['id'],
      title: data['title'],
      startDate: data['startDate'] != null ? DateTime.tryParse(data['startDate']) : null,
      endDate: data['endDate'] != null ? DateTime.tryParse(data['endDate']) : null,
      closeDate: data['closeDate'] != null ? DateTime.tryParse(data['closeDate']) : null,
      address: data['address'],
      status: data['status'],
      type: data['type'],
      description: data['description'],
      allowCompanions: data['allowCompanions'] as bool?,
      companions: data['companions'],
      tags: tagList,
      comment: data['comment'],
      questions: questionList,
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'address': address,
      'status': status,
      'type': type,
      'description': description,
      'companions': companions,
      'tags': tags?.map((tag) => tag.toJson()).toList() ?? [],
      'comment': comment,
    };
  }
}
