import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
import 'package:dev_once_app/features/auth/login/login_model.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';

class LoginVm extends BaseProvider {

  String? username;
  String? password;
  
  void onUsernameSaved(String? value) => username = value;

  void onPasswordSaved(String? value) => password = value;

  String? onUsernameValidate(String? value) {
    if (!value.existAndNotEmpty) return 'User ID is required';
    if (value!.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? onPasswordValidate(String? value) {
    if (!value.existAndNotEmpty) return 'Password is required';
    return null;
  }

  Future<({bool success, String? message})> login() async {
    setBusy(true);

    final request = LoginRequest(username: username!.trim(), password: password!);

    final config = RequestConfig<LoginResponse>(
      endpoint: '/auth/customer-login',
      request: request.toJson(),
      fromJson: LoginResponse.fromJson,
      isFormData: true,
    );

    ApiResponse response = await client.post(config);

    if(response.success) {
      client.setAuthToken(response.data!.accessToken);
      final resp = await _fetchMe(response.data!.accessToken);
      setBusy(false);

      if(!resp.success) {
        return (success: false, message: 'Error fetching user info');
      }
      final data = resp.data as SessionData;

      var message = 'dashboard';
      if (data.mandatoryInfo) { message = 'caution'; }

      return (success: true, message: message);
    }

    setBusy(false);
    return (success: false, message: response.message);
  }

  Future<ApiResponse> _fetchMe(String accessToken) async {
    final response = await client.post<SessionData>(
      RequestConfig<SessionData>(
        endpoint: '/auth/me',
        request: SessionRequest(accessToken: accessToken).toJson(),
        fromJson: SessionData.fromJson,
      ),
    );
    return response;
  }

}
