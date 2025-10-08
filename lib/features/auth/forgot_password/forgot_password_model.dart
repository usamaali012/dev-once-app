class ForgotPasswordRequest {
  final String username;

  const ForgotPasswordRequest({required this.username});

  Map<String, dynamic> toJson() => {
    'username': username,
  };
}

class ForgotPasswordResponse {
  final String userId;

  const ForgotPasswordResponse({required this.userId});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => ForgotPasswordResponse(
    userId: json['user_id'],
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
  };
}
