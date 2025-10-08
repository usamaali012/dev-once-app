import 'package:dev_once_app/core/models/base_provider.dart';

class CautionVm extends BaseProvider {
  // 0 = Father, 1 = Husband
  int nameType = 0;

  String? guardianName;
  String? mobile;
  String? cnic;
  String? address;
  String? nokName;
  String? nokMobile;
  String? nokCnic;
  String? relation;

  // UI helpers
  String get guardianLabel => nameType == 0 ? 'Father Name' : 'Husband Name';

  // Mutators
  void onNameTypeChanged(int? value) {
    nameType = value ?? 0;
    notifyListeners();
  }

  void onGuardianSaved(String? v) => guardianName = v?.trim();
  void onMobileSaved(String? v) => mobile = v?.trim();
  void onCnicSaved(String? v) => cnic = v?.trim();
  void onAddressSaved(String? v) => address = v?.trim();
  void onNokNameSaved(String? v) => nokName = v?.trim();
  void onNokMobileSaved(String? v) => nokMobile = v?.trim();
  void onNokCnicSaved(String? v) => nokCnic = v?.trim();
  void onRelationChanged(String? v) {
    relation = v;
    notifyListeners();
  }

  // Validators (simple required for now)
  String? req(String? v, {String label = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  String? onGuardianValidate(String? v) => req(v, label: guardianLabel);
  String? onMobileValidate(String? v) => req(v, label: 'Mobile No.');
  String? onCnicValidate(String? v) => req(v, label: 'CNIC');
  String? onAddressValidate(String? v) => req(v, label: 'Address');
  String? onNokNameValidate(String? v) => req(v, label: 'Next of Kin Name');
  String? onNokMobileValidate(String? v) => req(v, label: 'Next of Kin Mobile');
  String? onNokCnicValidate(String? v) => req(v, label: 'Next of Kin CNIC');
  String? onRelationValidate(String? v) => v == null || v.isEmpty ? 'Relation is required' : null;

  Future<({bool success, String? message})> submit() async {
    // No API for now; mimic busy state so the UI pattern matches others
    setBusy(true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    setBusy(false);
    return (success: true, message: null);
  }
}

