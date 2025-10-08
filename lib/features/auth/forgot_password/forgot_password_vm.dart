import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';

import 'forgot_password_model.dart';

class ForgotPasswordVm extends BaseProvider {
  String? username;
  String? userId;

  void onUsernameSaved(String? value) => username = value;

  String? onUsernameValidate(String? value) {
    if (value == null || value.trim().isEmpty) return 'User ID is required';
    if (value.trim().length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<({bool success, String? message})> submit() async {
    setBusy(true);

    final request = ForgotPasswordRequest(username: username!.trim());

    final res = await client.post<ForgotPasswordResponse>(
      RequestConfig<ForgotPasswordResponse>(
        endpoint: '/auth/forgot-password',
        request: request.toJson(),
        fromJson: ForgotPasswordResponse.fromJson
      ),
    );

    if (res.success) {
      userId = res.data!.userId;
      setBusy(false);
      
      return (success: true, message: null);
    }

    setBusy(false);
    return (success: false, message: res.message);
  }
}
