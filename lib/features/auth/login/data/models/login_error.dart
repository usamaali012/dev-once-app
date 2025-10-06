class LoginErrorDetail {
  final String? field;
  final String? message;

  const LoginErrorDetail({this.field, this.message});

  factory LoginErrorDetail.fromJson(Map<String, dynamic> json) => LoginErrorDetail(
        field: json['field'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'field': field,
        'message': message,
      };
}

class LoginError {
  final LoginErrorDetail? detail;

  const LoginError({this.detail});

  factory LoginError.fromJson(Map<String, dynamic> json) => LoginError(
        detail: json['detail'] is Map<String, dynamic>
            ? LoginErrorDetail.fromJson(json['detail'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'detail': detail?.toJson(),
      };
}

