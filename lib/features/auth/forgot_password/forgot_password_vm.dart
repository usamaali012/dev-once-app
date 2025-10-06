import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';

import 'forgot_password_model.dart';

class ForgotPasswordVm {
  final ApiClient _client;

  ForgotPasswordVm({ApiClient? client}) : _client = client ?? ApiClient();

  static const String _endpoint = '/auth/forgot-password';

  Future<ApiResponse<Map<String, dynamic>>> submit(
      ForgotPasswordRequest request) async {
    final res = await _client.post(
      RequestConfig<Map<String, dynamic>>(
        endpoint: _endpoint,
        request: request.toJson(),
      ),
    );
    
    return res;
  }
}

