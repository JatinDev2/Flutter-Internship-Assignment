class UserProfile {
  final String userId;
  final String username;
  final String email;
  final String profilePicUrl;

  UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.profilePicUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      userId: documentId,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePicUrl': profilePicUrl,
    };
  }
}
