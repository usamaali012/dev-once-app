class BankDetails {
  final String? accountTitle;
  final String? accountNumber;
  final String? ibanNumber;
  final String? bankName;
  final String? ownership; // e.g., Self/Joint/Company

  const BankDetails({
    this.accountTitle,
    this.accountNumber,
    this.ibanNumber,
    this.bankName,
    this.ownership,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    accountTitle: json['bank_account_title'],
    accountNumber: json['bank_account_number'],
    ibanNumber: json['bank_iban_number'],
    bankName: json['bank_name'],
    ownership: json['bank_account_ownership'],
  );

  Map<String, dynamic> toJson() => {
    'bank_account_title': accountTitle,
    'bank_account_number': accountNumber,
    'bank_iban_number': ibanNumber,
    'bank_name': bankName,
    'bank_account_ownership': ownership,
  };
}

