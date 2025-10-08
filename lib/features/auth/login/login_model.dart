class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json['username'],
        password: json['password'],
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

// Request body for /auth/me
class SessionRequest {
  final String accessToken;

  const SessionRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'token_type': 'bearer'
  };
}

// Response model for /auth/me (session data)
class SessionData {
  final String userId;
  final String role;
  final String username;
  final String name;
  final String? email;
  final bool isActive;
  final String profileImageUrl;
  final String? lastClosingId;
  final int? closingDate;
  final bool mandatoryInfo;
  final bool mandatoryBankInfo;
  final bool isManager;
  final bool canManage;
  final bool isSubManager;
  final bool canSubManage;
  final String customerUrl;
  final String suid;
  final List<String> permissions;

  const SessionData({
    required this.userId,
    required this.role,
    required this.username,
    required this.name,
    this.email,
    required this.isActive,
    required this.profileImageUrl,
    this.lastClosingId,
    this.closingDate,
    required this.mandatoryInfo,
    required this.mandatoryBankInfo,
    required this.isManager,
    required this.canManage,
    required this.isSubManager,
    required this.canSubManage,
    required this.customerUrl,
    required this.suid,
    required this.permissions,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
    userId: json['user_id'],
    role: json['role'],
    username: json['username'],
    name: json['name'],
    email: json['email'],
    isActive: json['is_active'],
    profileImageUrl: json['profile_image_url'],
    lastClosingId: json['last_closing_id'],
    closingDate: json['closing_date'] is int
      ? json['closing_date'] as int
      : int.tryParse((json['closing_date'] ?? '').toString()),
    mandatoryInfo: json['mandatory_info'],
    mandatoryBankInfo: json['mandatory_bank_info'],
    isManager: json['is_manager'],
    canManage: json['can_manage'],
    isSubManager: json['is_sub_manager'],
    canSubManage: json['can_sub_manage'],
    customerUrl: json['customer_url'],
    suid: json['suid'],
    permissions: (json['permissions'] as List?)
      ?.map((e) => e.toString())
      .toList() ?? const [],
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'role': role,
    'username': username,
    'name': name,
    'email': email,
    'is_active': isActive,
    'profile_image_url': profileImageUrl,
    'last_closing_id': lastClosingId,
    'closing_date': closingDate,
    'mandatory_info': mandatoryInfo,
    'mandatory_bank_info': mandatoryBankInfo,
    'is_manager': isManager,
    'can_manage': canManage,
    'is_sub_manager': isSubManager,
    'can_sub_manage': canSubManage,
    'customer_url': customerUrl,
    'suid': suid,
    'permissions': permissions,
  };
}

