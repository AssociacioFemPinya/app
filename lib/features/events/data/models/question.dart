class QuestionModel {
  final int id;
  final String text;
  final String type;
  final bool required;
  final int order;
  final List<String> options;
  final dynamic answer;

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.required,
    required this.order,
    required this.options,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'] as List? ?? [];
    final options = rawOptions.map((o) => o.toString()).toList();

    return QuestionModel(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      required: json['required'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
      options: options,
      answer: json['answer'],
    );
  }
}
