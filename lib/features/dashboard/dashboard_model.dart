class DashboardModel {
  final String? capital;
  final double? closingPayment;
  final double? lastDeposit;
  final int? lastDepositDate;
  final double? profitRatio;
  final double? businessRatio;
  final bool? isClosing;
  final int? closingDate;
  final bool? isClosingRequested;
  final bool? isWithdrawRequested;
  final bool? isWithdrawAllowed;
  final String? profileImageCompleteUrl;
  final String? username;
  final String? name;
  final int? enrollmentDate;
  final String? email;
  final String? mobile;
  final bool? isWhatsapp;
  final String? address;
  final double? rollover;
  final double? transfer;
  final double? totalReceived;
  final bool? autoRollover;
  final double? autoRolloverOn;
  final double? autoRolloverClosing;
  final int? autoRolloverRemainingClosing;

  const DashboardModel({
    this.capital,
    this.closingPayment,
    this.lastDeposit,
    this.lastDepositDate,
    this.profitRatio,
    this.businessRatio,
    this.isClosing,
    this.closingDate,
    this.isClosingRequested,
    this.isWithdrawRequested,
    this.isWithdrawAllowed,
    this.profileImageCompleteUrl,
    this.username,
    this.name,
    this.enrollmentDate,
    this.email,
    this.mobile,
    this.isWhatsapp,
    this.address,
    this.rollover,
    this.transfer,
    this.totalReceived,
    this.autoRollover,
    this.autoRolloverOn,
    this.autoRolloverClosing,
    this.autoRolloverRemainingClosing,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    capital: json['capital'],
    closingPayment: json['closing_payment'],
    lastDeposit: json['last_deposit'],
    lastDepositDate: json['last_deposit_date'],
    profitRatio: json['profit_ratio'],
    businessRatio: json['business_ratio'],
    isClosing: json['is_closing'],
    closingDate: json['closing_date'],
    isClosingRequested: json['is_closing_requested'],
    isWithdrawRequested: json['is_withdraw_requested'],
    isWithdrawAllowed: json['is_withdraw_allowed'],
    profileImageCompleteUrl: json['profile_image_complete_url'],
    username: json['username'],
    name: json['name'],
    enrollmentDate: json['enrollment_date'],
    email: json['email'],
    mobile: json['mobile'],
    isWhatsapp: json['is_whatsapp'],
    address: json['address'],
    rollover: json['rollover'],
    transfer: json['transfer'],
    totalReceived: json['total_received'],
    autoRollover: json['auto_rollover'],
    autoRolloverOn: json['auto_rollover_on'],
    autoRolloverClosing: json['auto_rollover_closing'],
    autoRolloverRemainingClosing: json['auto_rollover_remaining_closing'],
  );

  Map<String, dynamic> toJson() => {
    'capital': capital,
    'closing_payment': closingPayment,
    'last_deposit': lastDeposit,
    'last_deposit_date': lastDepositDate,
    'profit_ratio': profitRatio,
    'business_ratio': businessRatio,
    'is_closing': isClosing,
    'closing_date': closingDate,
    'is_closing_requested': isClosingRequested,
    'is_withdraw_requested': isWithdrawRequested,
    'is_withdraw_allowed': isWithdrawAllowed,
    'profile_image_complete_url': profileImageCompleteUrl,
    'username': username,
    'name': name,
    'enrollment_date': enrollmentDate,
    'email': email,
    'mobile': mobile,
    'is_whatsapp': isWhatsapp,
    'address': address,
    'rollover': rollover,
    'transfer': transfer,
    'total_received': totalReceived,
    'auto_rollover': autoRollover,
    'auto_rollover_on': autoRolloverOn,
    'auto_rollover_closing': autoRolloverClosing,
    'auto_rollover_remaining_closing': autoRolloverRemainingClosing,
  };
}

