class UserProfileData {
  String firstName;
  String paternalLastName;
  String? maternalLastName;
  String email;
  String? phone;
  DateTime? birthday;
  String? city;

  UserProfileData({
    required this.firstName,
    required this.paternalLastName,
    this.maternalLastName,
    required this.email,
    this.phone,
    this.birthday,
    this.city,
  });

  UserProfileData copyWith({
    String? firstName,
    String? paternalLastName,
    String? maternalLastName,
    String? email,
    String? phone,
    DateTime? birthday,
    String? city,
    String? postCode,
  }) {
    return UserProfileData(
      firstName: firstName ?? this.firstName,
      paternalLastName: paternalLastName ?? this.paternalLastName,
      maternalLastName: maternalLastName ?? this.maternalLastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      city: city ?? this.city,
    );
  }
}
