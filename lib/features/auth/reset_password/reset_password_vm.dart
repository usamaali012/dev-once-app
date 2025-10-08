import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_model.dart';

class ResetPasswordVm extends BaseProvider {
  // String? token;
  String? newPassword;
  String? confirmPassword;

  void onPasswordSaved(String? value) => newPassword = value?.trim();
  void onConfirmPasswordSaved(String? value) => confirmPassword = value?.trim();

  String? onPasswordValidate(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (v.contains(' ') || v.contains('|')) return 'Password cannot contain spaces or |';
    final hasUpper = v.contains(RegExp(r'[A-Z]'));
    final hasLower = v.contains(RegExp(r'[a-z]'));
    final hasNumOrSym = v.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>_+\-]'));
    if (!hasUpper || !hasLower) return 'Use uppercase and lowercase letters';
    if (!hasNumOrSym) return 'Include at least one number or symbol';
    return null;
  }

  String? onConfirmPasswordValidate(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Confirm password is required';
    return null;
  }

  Future<({bool success, String? message})> submit(String token) async {
    setBusy(true);
    final request = ResetPasswordRequest(token: token, newPassword: newPassword!);
    final resp = await client.post<Map<String, dynamic>>(
      RequestConfig<Map<String, dynamic>>(
        endpoint: '/auth/reset-password',
        request: request.toJson(),
      ),
    );
    setBusy(false);

    if (resp.success) {
      return (success: true, message: null);
    }
    return (success: false, message: resp.message);
  }
}
