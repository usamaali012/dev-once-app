import 'dart:async';

import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';
import 'package:dev_once_app/features/auth/otp/otp_model.dart';

class OtpVm extends BaseProvider {
  String? token;

  // OTP code state (VM-managed)
  static const int _defaultSeconds = 120;
  Timer? _timer;
  int _secondsLeft = _defaultSeconds;
  List<String> _digits = List.filled(6, '');

  int get secondsLeft => _secondsLeft;
  List<String> get digits => List.unmodifiable(_digits);
  bool get isCodeComplete => _digits.join().length == 6;
  String get code => _digits.join();

  void setDigit(int index, String value) {
    if (index < 0 || index >= _digits.length) return;
    final v = value.isEmpty ? '' : value[0];
    _digits[index] = v;
    notifyListeners();
  }

  void clearDigits() {
    _digits = List.filled(6, '');
    notifyListeners();
  }

  void startTimer([int seconds = _defaultSeconds]) {
    stopTimer();
    _secondsLeft = seconds;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        _secondsLeft = 0;
        t.cancel();
      } else {
        _secondsLeft -= 1;
      }
      notifyListeners();
    });
  }

  void resetTimer() => startTimer(_defaultSeconds);
  
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  bool get canResend => _secondsLeft == 0 && !isResendBusy;
  bool get canVerify => !isBusy;

  Future<({bool success, String? message})> resendOtp(String username) async {
    setResendBusy(true);

    final res = await client.post<OtpResendResponse>(
      RequestConfig<OtpResendResponse>(
        endpoint: '/auth/forgot-password',
        request: OtpResendRequest(username: username).toJson(),
        fromJson: OtpResendResponse.fromJson
      ),
    );

    setResendBusy(false);
    if (res.success) {
      resetTimer();
      clearDigits();
      return (success: true, message: null);
    }
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

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  bool isResendBusy = false;
  void setResendBusy(bool value) {
    isResendBusy = value;
    notifyListeners();
  }
}
