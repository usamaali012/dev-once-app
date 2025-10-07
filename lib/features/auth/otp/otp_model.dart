class OtpVerifyRequest {
  final String userId;
  final String otpCode;

  const OtpVerifyRequest({required this.userId, required this.otpCode});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'otp_code': otpCode,
      };
}

class OtpResendRequest {
  final String username;

  const OtpResendRequest({required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
      };
}

