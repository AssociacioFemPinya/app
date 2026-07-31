import 'package:equatable/equatable.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';

class UserProfileEntity extends Equatable {
  final int idCasteller;
  final int idCastellerExternal;
  final int collaId;
  final String numSoci;
  final String? nationality;
  final String? nationalIdNumber;
  final String? nationalIdType;
  final String? name;
  final String? lastName;
  final String? family;
  final String? familyHead;
  final String alias;
  final int gender;
  final String? birthdate;
  final String? subscriptionDate;
  final String email;
  final String email2;
  final String phone;
  final String? mobilePhone;
  final String? emergencyPhone;
  final String? address;
  final String? postalCode;
  final String? city;
  final String? comarca;
  final String? province;
  final String? country;
  final String? comments;
  final String? photo;
  final int height;
  final int weight;
  final int? shoulderHeight;
  final int status;
  final String? language;
  final int interactionType;
  final String createdAt;
  final String updatedAt;

  const UserProfileEntity({
    required this.idCasteller,
    required this.idCastellerExternal,
    required this.collaId,
    required this.numSoci,
    this.nationality,
    this.nationalIdNumber,
    this.nationalIdType,
    this.name,
    this.lastName,
    this.family,
    this.familyHead,
    required this.alias,
    required this.gender,
    this.birthdate,
    this.subscriptionDate,
    required this.email,
    required this.email2,
    required this.phone,
    this.mobilePhone,
    this.emergencyPhone,
    this.address,
    this.postalCode,
    this.city,
    this.comarca,
    this.province,
    this.country,
    this.comments,
    this.photo,
    required this.height,
    required this.weight,
    this.shoulderHeight,
    required this.status,
    this.language,
    required this.interactionType,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      idCasteller,
      idCastellerExternal,
      collaId,
      numSoci,
      nationality,
      nationalIdNumber,
      nationalIdType,
      name,
      lastName,
      family,
      familyHead,
      alias,
      gender,
      birthdate,
      subscriptionDate,
      email,
      email2,
      phone,
      mobilePhone,
      emergencyPhone,
      address,
      postalCode,
      city,
      comarca,
      province,
      country,
      comments,
      photo,
      height,
      weight,
      shoulderHeight,
      status,
      language,
      interactionType,
      createdAt,
      updatedAt,
    ];
  }

  // Factory constructor to create an RondaEntity from RondaModel
  factory UserProfileEntity.fromModel(UserProfileModel model) {
    return UserProfileEntity(
      idCasteller: model.idCasteller,
      idCastellerExternal: model.idCastellerExternal,
      collaId: model.collaId,
      numSoci: model.numSoci,
      nationality: model.nationality,
      nationalIdNumber: model.nationalIdNumber,
      nationalIdType: model.nationalIdType,
      name: model.name,
      lastName: model.lastName,
      family: model.family,
      familyHead: model.familyHead,
      alias: model.alias,
      gender: model.gender,
      birthdate: model.birthdate,
      subscriptionDate: model.subscriptionDate,
      email: model.email,
      email2: model.email2,
      phone: model.phone,
      mobilePhone: model.mobilePhone,
      emergencyPhone: model.emergencyPhone,
      address: model.address,
      postalCode: model.postalCode,
      city: model.city,
      comarca: model.comarca,
      province: model.province,
      country: model.country,
      comments: model.comments,
      photo: model.photo,
      height: model.height,
      weight: model.weight,
      shoulderHeight: model.shoulderHeight,
      status: model.status,
      language: model.language,
      interactionType: model.interactionType,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // Convert the entity to RondaModel
  UserProfileModel toModel() {
    return UserProfileModel(
      idCasteller: idCasteller,
      idCastellerExternal: idCastellerExternal,
      collaId: collaId,
      numSoci: numSoci,
      nationality: nationality,
      nationalIdNumber: nationalIdNumber,
      nationalIdType: nationalIdType,
      name: name,
      lastName: lastName,
      family: family,
      familyHead: familyHead,
      alias: alias,
      gender: gender,
      birthdate: birthdate,
      subscriptionDate: subscriptionDate,
      email: email,
      email2: email2,
      phone: phone,
      mobilePhone: mobilePhone,
      emergencyPhone: emergencyPhone,
      address: address,
      postalCode: postalCode,
      city: city,
      comarca: comarca,
      province: province,
      country: country,
      comments: comments,
      photo: photo,
      height: height,
      weight: weight,
      shoulderHeight: shoulderHeight,
      status: status,
      language: language,
      interactionType: interactionType,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  UserProfileEntity copyWith({
    int? idCasteller,
    int? idCastellerExternal,
    int? collaId,
    String? numSoci,
    String? nationality,
    String? nationalIdNumber,
    String? nationalIdType,
    String? name,
    String? lastName,
    String? family,
    String? familyHead,
    String? alias,
    int? gender,
    String? birthdate,
    String? subscriptionDate,
    String? email,
    String? email2,
    String? phone,
    String? mobilePhone,
    String? emergencyPhone,
    String? address,
    String? postalCode,
    String? city,
    String? comarca,
    String? province,
    String? country,
    String? comments,
    String? photo,
    int? height,
    int? weight,
    int? shoulderHeight,
    int? status,
    String? language,
    int? interactionType,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProfileEntity(
      idCasteller: idCasteller ?? this.idCasteller,
      idCastellerExternal: idCastellerExternal ?? this.idCastellerExternal,
      collaId: collaId ?? this.collaId,
      numSoci: numSoci ?? this.numSoci,
      nationality: nationality ?? this.nationality,
      nationalIdNumber: nationalIdNumber ?? this.nationalIdNumber,
      nationalIdType: nationalIdType ?? this.nationalIdType,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      family: family ?? this.family,
      familyHead: familyHead ?? this.familyHead,
      alias: alias ?? this.alias,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      email: email ?? this.email,
      email2: email2 ?? this.email2,
      phone: phone ?? this.phone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      comarca: comarca ?? this.comarca,
      province: province ?? this.province,
      country: country ?? this.country,
      comments: comments ?? this.comments,
      photo: photo ?? this.photo,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      shoulderHeight: shoulderHeight ?? this.shoulderHeight,
      status: status ?? this.status,
      language: language ?? this.language,
      interactionType: interactionType ?? this.interactionType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
