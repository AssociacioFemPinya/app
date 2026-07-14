class UserProfileModel {
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

  UserProfileModel({
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

  // Factory constructor for JSON deserialization
  factory UserProfileModel.fromJson(Map<String, dynamic> data) {
    return UserProfileModel(
      idCasteller:        data['id_casteller']          as int,
      idCastellerExternal: data['id_casteller_external'] as int,
      collaId:            data['colla_id']               as int,
      numSoci:            (data['num_soci']    as String?) ?? '',
      nationality:         data['nationality']  as String?,
      nationalIdNumber:    data['national_id_number'] as String?,
      nationalIdType:      data['national_id_type']   as String?,
      name:                data['name']         as String?,
      lastName:            data['last_name']    as String?,
      family:              data['family']       as String?,
      familyHead:          data['family_head']  as String?,
      alias:              (data['alias']        as String?) ?? '',
      gender:             (data['gender']       as int?)    ?? 0,
      birthdate:           data['birthdate']    as String?,
      subscriptionDate:    data['subscription_date'] as String?,
      email:              (data['email']        as String?) ?? '',
      email2:             (data['email2']       as String?) ?? '',
      phone:              (data['phone']        as String?) ?? '',
      mobilePhone:         data['mobile_phone']  as String?,
      emergencyPhone:      data['emergency_phone'] as String?,
      address:             data['address']      as String?,
      postalCode:          data['postal_code']  as String?,
      city:                data['city']         as String?,
      comarca:             data['comarca']      as String?,
      province:            data['province']     as String?,
      country:             data['country']      as String?,
      comments:            data['comments']     as String?,
      photo:               data['photo']        as String?,
      height:             (data['height']       as int?)    ?? 0,
      weight:             (data['weight']       as int?)    ?? 0,
      shoulderHeight:      data['shoulder_height'] as int?,
      status:             (data['status']       as int?)    ?? 1,
      language:            data['language']     as String?,
      interactionType:    (data['interaction_type'] as int?) ?? 0,
      createdAt:          (data['created_at']   as String?) ?? '',
      updatedAt:          (data['updated_at']   as String?) ?? '',
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_casteller': idCasteller,
      'id_casteller_external': idCastellerExternal,
      'colla_id': collaId,
      'num_soci': numSoci,
      'nationality': nationality,
      'national_id_number': nationalIdNumber,
      'national_id_type': nationalIdType,
      'name': name,
      'last_name': lastName,
      'family': family,
      'family_head': familyHead,
      'alias': alias,
      'gender': gender,
      'birthdate': birthdate,
      'subscription_date': subscriptionDate,
      'email': email,
      'email2': email2,
      'phone': phone,
      'mobile_phone': mobilePhone,
      'emergency_phone': emergencyPhone,
      'address': address,
      'postal_code': postalCode,
      'city': city,
      'comarca': comarca,
      'province': province,
      'country': country,
      'comments': comments,
      'photo': photo,
      'height': height,
      'weight': weight,
      'shoulder_height': shoulderHeight,
      'status': status,
      'language': language,
      'interaction_type': interactionType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
