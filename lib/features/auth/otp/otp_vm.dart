import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';
import 'package:dev_once_app/features/auth/otp/otp_model.dart';

class OtpVm {
  final ApiClient _client;

  OtpVm({ApiClient? client}) : _client = client ?? ApiClient();

  Future<ApiResponse<Map<String, dynamic>>> resendOtp(OtpResendRequest request) async {
    return await _client.post(
      RequestConfig<Map<String, dynamic>>(
        endpoint: '/auth/forgot-password',
        request: request.toJson(),
      ),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(OtpVerifyRequest request) async {
    return await _client.post(
      RequestConfig<Map<String, dynamic>>(
        endpoint: '/auth/verify-otp',
        request: request.toJson(),
      ),
    );
  }
}
