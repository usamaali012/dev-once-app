import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_model.dart';

class ResetPasswordVm {
  final ApiClient _client;

  ResetPasswordVm({ApiClient? client}) : _client = client ?? ApiClient();

  static const String _endpoint = '/auth/reset-password';

  Future<ApiResponse<Map<String, dynamic>>> submit(
    ResetPasswordRequest request,
  ) async {
    return await _client.post(
      RequestConfig<Map<String, dynamic>>(
        endpoint: _endpoint,
        request: request.toJson(),
      ),
    );
  }
}

