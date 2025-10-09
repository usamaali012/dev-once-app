import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
// import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';

import 'update_bank_details_model.dart';

class UpdateBankDetailsVm extends BaseProvider {
  BankDetails details = const BankDetails();

  String? accountTitle;
  String? accountNumber;
  String? ibanNumber;
  String? bankName;
  String? ownership;

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // onSaved handlers
  void onAccountTitleSaved(String? v) => accountTitle = v?.trim();
  void onAccountNumberSaved(String? v) => accountNumber = v?.trim();
  void onIbanSaved(String? v) => ibanNumber = v?.trim();
  void onBankNameChanged(String? v) {
    bankName = v;
    notifyListeners();
  }
  void onOwnershipChanged(String? v) {
    ownership = v;
    notifyListeners();
  }

  // Validators
  String? _req(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }
  String? onIbanValidate(String? v) => _req(v, 'IBAN Number');

  Future<({bool success, String? message})> get() async {
    setLoading(true);
    try {
      final config = RequestConfig<BankDetails>(
        endpoint: '/user/view-profile',
        fromJson: BankDetails.fromJson,
      );
      final res = await client.get(config);
      if (res.success) {
        details = res.data!;
        bankName = details.bankName;
        ownership = details.ownership;
        return (success: true, message: null);
      }
      return (success: false, message: res.message);
    } finally {
      setLoading(false);
    }
  }

  Future<({bool success, String? message})> update() async {
    setBusy(true);
    try {
      final req = BankDetails(
        accountTitle: accountTitle,
        accountNumber: accountNumber,
        ibanNumber: ibanNumber,
        bankName: bankName,
        ownership: ownership,
      );
      final cfg = RequestConfig(
        endpoint: '/user/user-bank-details',
        request: req.toJson(),
      );
      final res = await client.patch(cfg);
      if (res.success) return (success: true, message: null);
      return (success: false, message: res.message);
    } finally {
      setBusy(false);
    }
  }
}

