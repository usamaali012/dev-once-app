import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';
import 'package:dev_once_app/features/auth/login/data/models/login_request.dart';
import 'package:dev_once_app/features/auth/login/data/models/login_response.dart';

class LoginApi {
  final ApiClient _client;

  LoginApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    final res = await _client.post<LoginResponse>(
      RequestConfig<LoginResponse>(
        endpoint: '/auth/customer-login',
        request: request.toJson(),
        fromJson: (json) => LoginResponse.fromJson(json),
        isFormData: true
      ),
    );

    if (res.success && res.data?.accessToken.isNotEmpty == true) {
      _client.setAuthToken(res.data!.accessToken);
    }
    return res;
  }
}

