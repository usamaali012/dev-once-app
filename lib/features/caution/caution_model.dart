class MandatoryInfo {
  final String? fatherName;
  final String? husbandName;
  final String? mobile;
  final bool? isWhatsapp;
  final String? cnic;
  final String? address;
  final String? nokName;
  final String? nokPhone;
  final String? nokCnic;
  final bool? nokIsWhatsapp;
  final String? nokRelation;

  const MandatoryInfo({
    this.fatherName, 
    this.husbandName,
    this.mobile,
    this.isWhatsapp = false,
    this.cnic,
    this.address,
    this.nokName,
    this.nokPhone,
    this.nokCnic,
    this.nokIsWhatsapp = false,
    this.nokRelation,

  });

  factory MandatoryInfo.fromJson(Map<String, dynamic> json) => MandatoryInfo(
    fatherName: json['father_name'],
    husbandName: json['husband_name'],
    mobile: json['mobile'],
    isWhatsapp: json['is_whatsapp'],
    cnic: json['cnic'],
    address: json['address'],
    nokName: json['next_of_kin_name'],
    nokPhone: json['next_of_kin_phone'],
    nokCnic: json['next_of_kin_cnic'],
    nokIsWhatsapp: json['next_of_kin_is_whatsapp'],
    nokRelation: json['next_of_kin_relation'],
  );

  Map<String, dynamic> toJson() => {
    'father_name': fatherName,
    'husband_name': husbandName,
    'mobile': mobile,
    'is_whatsapp': isWhatsapp,
    'cnic': cnic,
    'address': address,
    'next_of_kin_name': nokName,
    'next_of_kin_phone': nokPhone,
    'next_of_kin_cnic': nokCnic,
    'next_of_kin_is_whatsapp': nokIsWhatsapp,
    'next_of_kin_relation': nokRelation,
  };
}