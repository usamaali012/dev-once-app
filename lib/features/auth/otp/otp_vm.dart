import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
import 'package:dev_once_app/features/auth/otp/otp_model.dart';

class OtpVm extends BaseProvider {
  String? token;

  Future<({bool success, String? message})> resendOtp(String username) async {
    setBusy(true);

    final res = await client.post<OtpResendResponse>(
      RequestConfig<OtpResendResponse>(
        endpoint: '/auth/forgot-password',
        request: OtpResendRequest(username: username).toJson(),
      ),
    );

    setBusy(false);
    if (res.success) return (success: true, message: null);
    return (success: false, message: res.message);
  }

  Future<({bool success, String? message})> verifyOtp({
    required String userId,
    required String code
  }) async {
    setBusy(true);

    final resp = await client.post<OtpVerifyResponse>(
      RequestConfig<OtpVerifyResponse>(
        endpoint: '/auth/verify-otp',
        request: OtpVerifyRequest(userId: userId, otpCode: code).toJson(),
        fromJson: OtpVerifyResponse.fromJson
      ),
    );

    setBusy(false);
    if (resp.success) {
      token = resp.data!.token;
      return (success: true, message: null);
    }
    return (success: false, message: resp.message);
  }
}
