import 'package:equatable/equatable.dart';
import 'package:femcastells/features/rondes/rondes.dart';

class PublicDisplayUrlEntity extends Equatable {
  final String publicUrl;

  const PublicDisplayUrlEntity({
    required this.publicUrl,
  });

  @override
  List<Object?> get props {
    return [publicUrl];
  }

  // Factory constructor to create an RondaEntity from RondaModel
  factory PublicDisplayUrlEntity.fromModel(PublicDisplayUrlModel model) {
    return PublicDisplayUrlEntity(
      publicUrl: model.publicUrl ?? '',
    );
  }

  // Convert the entity to RondaModel
  PublicDisplayUrlModel toModel() {
    return PublicDisplayUrlModel(
      publicUrl: publicUrl,
    );
  }

  PublicDisplayUrlEntity copyWith({String? publicUrl}) {
    return PublicDisplayUrlEntity(
      publicUrl: publicUrl ?? this.publicUrl,
    );
  }
}
