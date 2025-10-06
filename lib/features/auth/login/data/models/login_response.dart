class LoginResponse {
  final String accessToken;

  const LoginResponse({required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['access_token'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
      };
}

