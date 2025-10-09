import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/features/caution/caution_model.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';


class CautionVm extends BaseProvider {
  // 0 = Father, 1 = Husband
  int guardianType = 0;

  MandatoryInfo data = MandatoryInfo();
  String? fatherName;
  String? husbandName;
  String? mobile;
  String? cnic;
  String? address;
  String? nokName;
  String? nokMobile;
  String? nokCnic;
  String? relation;

  // UI helpers
  String get guardianLabel => guardianType == 0 ? 'Father Name' : 'Husband Name';

  // Mutators
  void onGuardianTypeChanged(int? value) {
    guardianType = value ?? 0;
    notifyListeners();
  }

  void onGuardianSaved(String? v) {
    final guardianName = v?.trim();

    if (guardianType == 0) {
      fatherName = guardianName;
      husbandName = null;
    } else {
      husbandName = guardianName;
      fatherName = null;
    }
  }
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

  Future<({bool success, String? message})> get() async {
    setLoading(true);
    final config = RequestConfig<MandatoryInfo>(
      endpoint: '/user/get-mandatory-info',
      fromJson: MandatoryInfo.fromJson
    );

    final response = await client.get(config);

    if(response.success) {
      data = response.data!;
      if (data.husbandName.existAndNotEmpty) { guardianType = 1; }
      else { guardianType = 0; }
      setLoading(false);
      return (success: true, message: null);
    } else {
      setLoading(false);
      return (success: true, message: null);
    }
  }
  
  Future<({bool success, String? message})> update() async {
    setBusy(true);

    final request = MandatoryInfo(
      fatherName: fatherName, 
      husbandName: husbandName,
      mobile: mobile,
      cnic: cnic,
      address: address,
      nokName: nokName,
      nokPhone: nokMobile,
      nokCnic: nokCnic,
      nokRelation: relation,
    );

    final config = RequestConfig(
      endpoint: '/user/update-mandatory-info',
      request: request.toJson(),
    );

    final response = await client.patch(config);

    setBusy(false);
    if(response.success) {
      return (success: true, message: null);
    } else {
      return (success: false, message: response.message);
    }
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
