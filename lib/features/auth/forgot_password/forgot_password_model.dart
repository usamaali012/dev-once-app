class ForgotPasswordRequest {
  final String username;

  const ForgotPasswordRequest({required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
      };
}

