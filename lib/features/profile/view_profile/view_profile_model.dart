class ViewProfileModel {
  final String? name;
  final String? fatherName;
  final String? husbandName;
  final String? cnic;
  final String? email;
  final String? mobile;
  final String? address;
  final String? nokName;
  final String? nokPhone;
  final String? nokCnic;
  final String? nokRelation;
  final String? profileImageUrl;
  final String? profileImageCompleteUrl;
  final String? accountTitle;
  final String? accountNumber;
  final String? ibanNumber;
  final String? bankName;
  final String? ownership;

  const ViewProfileModel({
    this.name,
    this.fatherName,
    this.husbandName,
    this.cnic,
    this.email,
    this.mobile,
    this.address,
    this.nokName,
    this.nokPhone,
    this.nokCnic,
    this.nokRelation,
    this.profileImageUrl,
    this.profileImageCompleteUrl,
    this.accountTitle,
    this.accountNumber,
    this.ibanNumber,
    this.bankName,
    this.ownership,
  });

  factory ViewProfileModel.fromJson(Map<String, dynamic> json) => ViewProfileModel(
    name: json['name'],
    fatherName: json['father_name'],
    husbandName: json['husband_name'],
    cnic: json['cnic'],
    email: json['email'],
    mobile: json['mobile'],
    address: json['address'],
    nokName: json['next_of_kin_name'],
    nokPhone: json['next_of_kin_phone'],
    nokCnic: json['next_of_kin_cnic'],
    nokRelation: json['next_of_kin_relation'],
    profileImageUrl: json['profile_image_url'],
    profileImageCompleteUrl: json['profile_image_complete_url'],
    accountTitle: json['bank_account_title'],
    accountNumber: json['bank_account_number'],
    ibanNumber: json['bank_iban_number'],
    bankName: json['bank_name'],
    ownership: json['bank_account_ownership'],
  );

  Map<String, dynamic> toJson() => {
    'father_name': fatherName,
    'husband_name': husbandName,
    'cnic': cnic,
    'email': email,
    'mobile': mobile,
    'address': address,
    'next_of_kin_name': nokName,
    'next_of_kin_phone': nokPhone,
    'next_of_kin_cnic': nokCnic,
    'next_of_kin_relation': nokRelation,
    'profile_image_url': profileImageUrl,
    'profile_image_complete_url': profileImageCompleteUrl,
    'bank_account_title': accountTitle,
    'bank_account_number': accountNumber,
    'bank_iban_number': ibanNumber,
    'bank_name': bankName,
    'bank_account_ownership': ownership,
  };
}

