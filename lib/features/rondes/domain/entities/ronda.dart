import 'package:equatable/equatable.dart';
import 'package:femcastells/features/rondes/rondes.dart';

class RondaEntity extends Equatable {
  final int id;
  final String publicUrl;
  final int ronda;
  final String name;

  const RondaEntity({
    required this.id,
    required this.publicUrl,
    required this.ronda,
    this.name = "Default event",
  });

  @override
  List<Object?> get props {
    return [id, publicUrl, ronda, name];
  }

  // Factory constructor to create an RondaEntity from RondaModel
  factory RondaEntity.fromModel(RondaModel model) {
    return RondaEntity(
      id: model.id ?? 0,
      publicUrl: model.publicUrl ?? '',
      ronda: model.ronda ?? 0,
      name: model.name ?? '',
    );
  }

  // Convert the entity to RondaModel
  RondaModel toModel() {
    return RondaModel(
      id: id,
      publicUrl: publicUrl,
      ronda: ronda,
      name: name,
    );
  }

  RondaEntity copyWith() {
    return RondaEntity(
      id: id,
      publicUrl: publicUrl,
      ronda: ronda,
      name: name,
    );
  }
}
