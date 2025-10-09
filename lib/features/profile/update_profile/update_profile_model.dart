class ProfileDetails {
  final String? email;
  final String? mobile;
  final String? address;
  final String? nokName;
  final String? nokPhone;
  final String? nokCnic;
  final String? nokRelation;

  const ProfileDetails({
    this.email,
    this.mobile,
    this.address,
    this.nokName,
    this.nokPhone,
    this.nokCnic,
    this.nokRelation,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
        email: json['email'],
        mobile: json['mobile'],
        address: json['address'],
        nokName: json['next_of_kin_name'],
        nokPhone: json['next_of_kin_phone'],
        nokCnic: json['next_of_kin_cnic'],
        nokRelation: json['next_of_kin_relation'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'mobile': mobile,
        'address': address,
        'next_of_kin_name': nokName,
        'next_of_kin_phone': nokPhone,
        'next_of_kin_cnic': nokCnic,
        'next_of_kin_relation': nokRelation,
      };
}

