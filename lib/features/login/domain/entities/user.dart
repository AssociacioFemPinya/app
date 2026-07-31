import 'package:femcastells/features/login/login.dart';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int castellerActiveId;
  final String castellerActiveAlias;
  final List<LinkedCastellerEntity> linkedCastellers;
  final bool boardsEnabled;
  final String? collaName;
  final String? collaLogoUrl;

  const UserEntity({
    required this.castellerActiveId,
    required this.castellerActiveAlias,
    required this.linkedCastellers,
    required this.boardsEnabled,
    this.collaName,
    this.collaLogoUrl,
  });

  @override
  List<Object?> get props => [
        castellerActiveId,
        castellerActiveAlias,
        linkedCastellers,
        boardsEnabled,
        collaName,
        collaLogoUrl,
      ];

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      castellerActiveId: model.castellerActiveId,
      castellerActiveAlias: model.castellerActiveAlias,
      linkedCastellers: model.linkedCastellers
          .map((casteller) => LinkedCastellerEntity.fromModel(casteller))
          .toList(),
      boardsEnabled: model.boardsEnabled,
      collaName: model.collaName,
      collaLogoUrl: model.collaLogoUrl,
    );
  }

  UserModel toModel() {
    return UserModel(
      castellerActiveId: castellerActiveId,
      castellerActiveAlias: castellerActiveAlias,
      linkedCastellers:
          linkedCastellers.map((casteller) => casteller.toModel()).toList(),
      boardsEnabled: boardsEnabled,
      collaName: collaName,
      collaLogoUrl: collaLogoUrl,
    );
  }

  UserEntity copyWith({
    int? castellerActiveId,
    String? castellerActiveAlias,
    List<LinkedCastellerEntity>? linkedCastellers,
    bool? boardsEnabled,
    String? collaName,
    String? collaLogoUrl,
  }) {
    return UserEntity(
      castellerActiveId: castellerActiveId ?? this.castellerActiveId,
      castellerActiveAlias: castellerActiveAlias ?? this.castellerActiveAlias,
      linkedCastellers: linkedCastellers ?? this.linkedCastellers,
      boardsEnabled: boardsEnabled ?? this.boardsEnabled,
      collaName: collaName ?? this.collaName,
      collaLogoUrl: collaLogoUrl ?? this.collaLogoUrl,
    );
  }

  static const empty = UserEntity(
    castellerActiveId: 0,
    castellerActiveAlias: '-',
    linkedCastellers: [],
    boardsEnabled: false,
  );

  @override
  String toString() {
    return 'UserEntity(castellerActiveId: $castellerActiveId, '
        'castellerActiveAlias: $castellerActiveAlias, '
        'linkedCastellers: $linkedCastellers, '
        'boardsEnabled: $boardsEnabled, '
        'collaName: $collaName)';
  }
}

class LinkedCastellerEntity extends Equatable {
  final int idCastellerApiUser;
  final int apiUserId;
  final int castellerId;

  const LinkedCastellerEntity({
    required this.idCastellerApiUser,
    required this.apiUserId,
    required this.castellerId,
  });

  @override
  List<Object?> get props {
    return [
      idCastellerApiUser,
      apiUserId,
      castellerId,
    ];
  }

  // Factory constructor to create a LinkedCastellerEntity from LinkedCasteller
  factory LinkedCastellerEntity.fromModel(LinkedCasteller model) {
    return LinkedCastellerEntity(
      idCastellerApiUser: model.idCastellerApiUser,
      apiUserId: model.apiUserId,
      castellerId: model.castellerId,
    );
  }

  // Convert the entity to LinkedCasteller
  LinkedCasteller toModel() {
    return LinkedCasteller(
      idCastellerApiUser: idCastellerApiUser,
      apiUserId: apiUserId,
      castellerId: castellerId,
    );
  }

  @override
  String toString() {
    return 'LinkedCasteller(idCastellerApiUser: $idCastellerApiUser, '
        'apiUserId: $apiUserId, '
        'castellerId: $castellerId)';
  }
}
