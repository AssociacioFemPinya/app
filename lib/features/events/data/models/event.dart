import 'package:fempinya3_flutter_app/features/events/data/models/tag.dart';

class EventModel {
  final int? id;
  final String? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? address;
  final String? status;
  final String? type;
  final String? description;
  final String? locationLink;
  final DateTime? registrationOpenDate;
  final DateTime? registrationCloseDate;
  final String registrationStatus;
  final int? companions;
  final bool allowsCompanions;
  final List<TagModel>? tags;

  EventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.status,
    required this.type,
    required this.description,
    this.locationLink,
    this.registrationOpenDate,
    this.registrationCloseDate,
    this.registrationStatus = 'open',
    required this.companions,
    this.allowsCompanions = false,
    required this.tags,
  });

  // Factory constructor for JSON deserialization
  factory EventModel.fromJson(Map<String, dynamic> data) {
    var tagsFromJson = data['tags'] as List?;
    List<TagModel>? tagList =
        tagsFromJson?.map((tag) => TagModel.fromJson(tag)).toList();

    return EventModel(
      id: data['id'],
      title: data['title'],
      startDate: data['startDate'] != null
          ? DateTime.tryParse(data['startDate'])
          : null,
      endDate:
          data['endDate'] != null ? DateTime.tryParse(data['endDate']) : null,
      address: data['address'],
      status: data['status'],
      type: data['type'],
      description: data['description'],
      locationLink: data['locationLink'],
      registrationOpenDate: data['registrationOpenDate'] != null
          ? DateTime.tryParse(data['registrationOpenDate'])
          : null,
      registrationCloseDate: data['registrationCloseDate'] != null
          ? DateTime.tryParse(data['registrationCloseDate'])
          : null,
      registrationStatus: data['registrationStatus'] ?? 'open',
      companions: data['companions'],
      allowsCompanions: data['allowsCompanions'] ?? false,
      tags: tagList,
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
      'locationLink': locationLink,
      'registrationOpenDate': registrationOpenDate?.toIso8601String(),
      'registrationCloseDate': registrationCloseDate?.toIso8601String(),
      'registrationStatus': registrationStatus,
      'companions': companions,
      'allowsCompanions': allowsCompanions,
      'tags': tags?.map((tag) => tag.toJson()).toList() ?? [],
    };
  }
}
