class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

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
