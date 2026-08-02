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
      idCasteller: data['id_casteller'],
      idCastellerExternal: data['id_casteller_external'] ?? 0,
      collaId: data['colla_id'],
      numSoci: data['num_soci'] ?? '',
      nationality: data['nationality'],
      nationalIdNumber: data['national_id_number'],
      nationalIdType: data['national_id_type'],
      name: data['name'],
      lastName: data['last_name'],
      family: data['family'],
      familyHead: data['family_head'],
      alias: data['alias'],
      gender: data['gender'],
      birthdate: data['birthdate'],
      subscriptionDate: data['subscription_date'],
      email: data['email'],
      email2: data['email2'] ?? '',
      phone: data['phone'],
      mobilePhone: data['mobile_phone'],
      emergencyPhone: data['emergency_phone'],
      address: data['address'],
      postalCode: data['postal_code'],
      city: data['city'],
      comarca: data['comarca'],
      province: data['province'],
      country: data['country'],
      comments: data['comments'],
      photo: data['photo'],
      height: data['height'],
      weight: data['weight'],
      shoulderHeight: data['shoulder_height'],
      status: data['status'],
      language: data['language'],
      interactionType: data['interaction_type'] ?? 0,
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
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
