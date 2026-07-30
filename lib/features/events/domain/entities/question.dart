import 'package:equatable/equatable.dart';
import 'package:femcastells/features/events/data/models/question.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String text;
  final String type;
  final bool required;
  final int order;
  final List<String> options;
  final dynamic answer;

  const QuestionEntity({
    required this.id,
    required this.text,
    required this.type,
    required this.required,
    required this.order,
    required this.options,
    required this.answer,
  });

  factory QuestionEntity.fromModel(QuestionModel model) {
    return QuestionEntity(
      id: model.id,
      text: model.text,
      type: model.type,
      required: model.required,
      order: model.order,
      options: model.options,
      answer: model.answer,
    );
  }

  QuestionEntity copyWith({dynamic answer}) {
    return QuestionEntity(
      id: id,
      text: text,
      type: type,
      required: required,
      order: order,
      options: options,
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [id, text, type, required, order, options, answer];
}
