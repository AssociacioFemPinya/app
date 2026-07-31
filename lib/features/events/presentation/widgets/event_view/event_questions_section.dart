import 'package:flutter/material.dart';
import 'package:femcastells/features/events/domain/entities/question.dart';

class EventQuestionsSection extends StatefulWidget {
  final List<QuestionEntity> questions;
  final void Function(List<Map<String, dynamic>> answers) onSave;
  final bool readOnly;

  const EventQuestionsSection({
    super.key,
    required this.questions,
    required this.onSave,
    this.readOnly = false,
  });

  @override
  State<EventQuestionsSection> createState() => _EventQuestionsSectionState();
}

class _EventQuestionsSectionState extends State<EventQuestionsSection> {
  late Map<int, dynamic> _answers;

  @override
  void initState() {
    super.initState();
    _answers = {
      for (final q in widget.questions) q.id: _parseInitialAnswer(q),
    };
  }

  dynamic _parseInitialAnswer(QuestionEntity q) {
    if (q.answer == null) return q.type == 'checkbox' ? <String>[] : null;
    if (q.type == 'checkbox' && q.answer is List) {
      return List<String>.from(q.answer as List);
    }
    return q.answer?.toString();
  }

  bool _isEmpty(dynamic val) {
    if (val == null) return true;
    if (val is String) return val.trim().isEmpty;
    if (val is List) return val.isEmpty;
    return false;
  }

  void _save() {
    final unanswered = widget.questions.where((q) => q.required && _isEmpty(_answers[q.id])).toList();
    if (unanswered.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cal respondre les preguntes obligatòries (*): ${unanswered.map((q) => q.text).join(', ')}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    final answers = _answers.entries.map((e) => {
      'question_id': e.key,
      'answer': e.value,
    }).toList();
    widget.onSave(answers);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Informació adicional',
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.questions.map((q) => _buildQuestion(context, q)),
        const SizedBox(height: 16),
        if (!widget.readOnly)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Desar respostes'),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context, QuestionEntity q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  q.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (q.required)
                Text(' *', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ),
          const SizedBox(height: 4),
          switch (q.type) {
            'radio'    => _buildRadio(q),
            'checkbox' => _buildCheckbox(q),
            _          => _buildText(q),
          },
        ],
      ),
    );
  }

  Widget _buildRadio(QuestionEntity q) {
    final current = _answers[q.id] as String?;
    return Column(
      children: q.options.map((opt) => RadioListTile<String>(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(opt),
        value: opt,
        groupValue: current,
        onChanged: widget.readOnly ? null : (val) => setState(() => _answers[q.id] = val),
      )).toList(),
    );
  }

  Widget _buildCheckbox(QuestionEntity q) {
    final current = (_answers[q.id] as List<String>?) ?? [];
    return Column(
      children: q.options.map((opt) => CheckboxListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(opt),
        value: current.contains(opt),
        onChanged: widget.readOnly ? null : (checked) => setState(() {
          final list = List<String>.from(current);
          if (checked == true) {
            list.add(opt);
          } else {
            list.remove(opt);
          }
          _answers[q.id] = list;
        }),
      )).toList(),
    );
  }

  Widget _buildText(QuestionEntity q) {
    return TextFormField(
      initialValue: _answers[q.id]?.toString(),
      maxLines: 3,
      readOnly: widget.readOnly,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: widget.readOnly ? null : (val) => _answers[q.id] = val.isEmpty ? null : val,
    );
  }
}
