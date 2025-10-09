import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';

import 'update_profile_model.dart';

class UpdateProfileVm extends BaseProvider {
  ProfileDetails details = const ProfileDetails();

  String? email;
  String? mobile;
  String? address;
  String? nokName;
  String? nokMobile;
  String? nokCnic;
  String? relation;
  String? profileImageUrl;
  String? profileImageCompleteUrl;

  bool isLoading = false;
  void setLoading(bool value) { isLoading = value; notifyListeners(); }

  void onEmailSaved(String? v) => email = v?.trim();
  void onMobileSaved(String? v) => mobile = v?.trim();
  void onAddressSaved(String? v) => address = v?.trim();
  void onNokNameSaved(String? v) => nokName = v?.trim();
  void onNokMobileSaved(String? v) => nokMobile = v?.trim();
  void onNokCnicSaved(String? v) => nokCnic = v?.trim();
  void onRelationChanged(String? v) { relation = v; notifyListeners(); }

  String? _req(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }
  String? onEmailValidate(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  String? onNokNameValidate(String? v) => _req(v, 'Next of Kin Name');
  String? onNokMobileValidate(String? v) => _req(v, 'Next of Kin Mobile');
  String? onNokCnicValidate(String? v) => _req(v, 'Next of Kin CNIC');
  String? onRelationValidate(String? v) => (v == null || v.isEmpty) ? 'Relation is required' : null;

  Future<({bool success, String? message})> get() async {
    setLoading(true);
    try {
      final cfg = RequestConfig<ProfileDetails>(
        endpoint: '/user/view-profile',
        fromJson: ProfileDetails.fromJson,
      );
      final res = await client.get(cfg);
      if (res.success) {
        details = res.data!;
        relation = details.nokRelation;
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
      final req = ProfileDetails(
        email: email,
        mobile: mobile,
        address: address,
        nokName: nokName,
        nokPhone: nokMobile,
        nokCnic: nokCnic,
        nokRelation: relation,
        profileImageUrl: profileImageUrl 
      );
      final cfg = RequestConfig(
        endpoint: '/user/update-profile',
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

