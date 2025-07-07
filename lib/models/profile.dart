class UserProfile {
  final String id;
  final String fullName;
  final String? email;       
  final String? avatarUrl;   
  final String role;

  UserProfile({
    required this.id,
    required this.fullName,
    this.email,
    this.avatarUrl,
    required this.role,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }
}
