import 'package:flutter/foundation.dart';
import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';

import 'login_model.dart';

class LoginVm extends ChangeNotifier {
  final ApiClient _client;

  LoginVm({ApiClient? client}) : _client = client ?? ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  static const String _loginEndpoint = '/auth/customer-login';

  Future<ApiResponse<LoginResponse>> login({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final req = LoginRequest(username: username, password: password);
      final res = await _client.post<LoginResponse>(
        RequestConfig<LoginResponse>(
          endpoint: _loginEndpoint,
          request: req.toJson(),
          fromJson: (json) => LoginResponse.fromJson(json),
          isFormData: true,
        ),
      );

      if (res.success && (res.data?.accessToken.isNotEmpty == true)) {
        _client.setAuthToken(res.data!.accessToken);
      }
      return res;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }
}
