import 'package:femcastells/features/rondes/data/models/ronda.dart';

class HistorialEventModel {
  final int eventId;
  final String eventName;
  final String eventDate;
  final int eventType;
  final List<RondaModel> rondes;

  const HistorialEventModel({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventType,
    required this.rondes,
  });

  factory HistorialEventModel.fromJson(Map<String, dynamic> json) =>
      HistorialEventModel(
        eventId:   json['eventId'] as int,
        eventName: json['eventName'] as String,
        eventDate: json['eventDate'] as String,
        eventType: json['eventType'] as int,
        rondes:    (json['rondes'] as List)
            .map((r) => RondaModel.fromJson(r as Map<String, dynamic>))
            .toList(),
      );
}
