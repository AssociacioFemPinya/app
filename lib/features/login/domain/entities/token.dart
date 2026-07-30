import 'package:femcastells/features/login/login.dart';

import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String access_token;
  final String token_type;

  const TokenEntity({required this.access_token, required this.token_type});

  @override
  List<Object?> get props {
    return [access_token];
  }

  // Factory constructor to create an EventEntity from EventModel
  factory TokenEntity.fromModel(TokenModel model) {
    return TokenEntity(
      access_token: model.access_token,
      token_type: model.token_type,
    );
  }

  // Convert the entity to EventModel
  TokenModel toModel() {
    return TokenModel(
      access_token: access_token,
      token_type: token_type,
    );
  }

  TokenEntity copyWith({bool? isEnabled}) {
    return TokenEntity(
      access_token: access_token,
      token_type: token_type,
    );
  }

  static const empty = TokenEntity(access_token: '-', token_type: '-');
}
