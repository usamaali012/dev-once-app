import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';

import 'login_model.dart';

class LoginVm {
  final ApiClient _client;

  LoginVm({ApiClient? client}) : _client = client ?? ApiClient();

  // Adjust this to your backend route
  static const String _loginEndpoint = '/auth/login';

  Future<ApiResponse<LoginResponse>> login({
    required String username,
    required String password,
    bool asForm = false,
  }) async {
    final req = LoginRequest(username: username, password: password);
    final res = await _client.post<LoginResponse>(
      RequestConfig<LoginResponse>(
        endpoint: _loginEndpoint,
        request: req.toJson(),
        fromJson: (json) => LoginResponse.fromJson(json),
        isFormData: asForm,
      ),
    );

    if (res.success && res.data?.accessToken.isNotEmpty == true) {
      _client.setAuthToken(res.data!.accessToken);
    }
    return res;
  }
}
