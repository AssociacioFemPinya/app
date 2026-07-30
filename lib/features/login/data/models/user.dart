class UserModel {
  final int castellerActiveId;
  final String castellerActiveAlias;
  final List<LinkedCasteller> linkedCastellers;
  final bool boardsEnabled;
  final String? collaName;
  final String? collaLogoUrl;

  UserModel({
    required this.castellerActiveId,
    required this.castellerActiveAlias,
    required this.linkedCastellers,
    required this.boardsEnabled,
    this.collaName,
    this.collaLogoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'castellerActiveId': castellerActiveId,
      'castellerActiveAlias': castellerActiveAlias,
      'linkedCastellers':
          linkedCastellers.map((casteller) => casteller.toJson()).toList(),
      'boardsEnabled': boardsEnabled,
      'collaName': collaName,
      'collaLogoUrl': collaLogoUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      castellerActiveId: data['castellerActiveId'] as int,
      castellerActiveAlias: data['castellerActiveAlias'] as String,
      linkedCastellers: (data['linkedCastellers'] as List?)
              ?.map((castellerData) {
                if (castellerData is Map<String, dynamic>) {
                  return LinkedCasteller.fromJson(castellerData);
                }
                return null;
              })
              .whereType<LinkedCasteller>()
              .toList() ??
          [],
      boardsEnabled: data['boardsEnabled'] as bool,
      collaName: data['collaName'] as String?,
      collaLogoUrl: data['collaLogoUrl'] as String?,
    );
  }
}

class LinkedCasteller {
  final int idCastellerApiUser;
  final int apiUserId;
  final int castellerId;

  LinkedCasteller({
    required this.idCastellerApiUser,
    required this.apiUserId,
    required this.castellerId,
  });

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'idCastellerApiUser': idCastellerApiUser,
      'apiUserId': apiUserId,
      'castellerId': castellerId,
    };
  }

  // Factory constructor for JSON deserialization
  factory LinkedCasteller.fromJson(Map<String, dynamic> data) {
    return LinkedCasteller(
      idCastellerApiUser: data['idCastellerApiUser'] as int? ?? 0,
      apiUserId: data['apiUserId'] as int? ?? 0,
      castellerId: data['castellerId'] as int? ?? 0,
    );
  }
}
