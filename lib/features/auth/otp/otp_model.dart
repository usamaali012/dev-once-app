class OtpVerifyRequest {
  final String userId;
  final String otpCode;

  const OtpVerifyRequest({required this.userId, required this.otpCode});

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'otp_code': otpCode,
  };
}

class OtpVerifyResponse {
  final String token;

  const OtpVerifyResponse({required this.token});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) => OtpVerifyResponse(
    token: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}

class OtpResendRequest {
  final String username;

  const OtpResendRequest({required this.username});

  Map<String, dynamic> toJson() => {
    'username': username,
  };
}

class OtpResendResponse {
  final String userId;

  const OtpResendResponse({required this.userId});

  factory OtpResendResponse.fromJson(Map<String, dynamic> json) => OtpResendResponse(
    userId: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
  };
}
