class UserData {
  final String username;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String userId;
  final String email;
  final DateTime dateJoined;
  final bool isAccountActive;

  UserData({
    required this.username,
    required this.photoUrl,
    required this.userId,
    required this.email,
    required this.dateJoined,
    required this.firstName,
    required this.lastName,
    required this.isAccountActive,
  });

  factory UserData.fromToken(Map<String, dynamic> payload) {
    return UserData(
      username: payload['username'] ?? '',
      photoUrl: payload['photo'] ?? '',
      userId: payload['user_id'] ?? '',
      email: payload['email'] ?? '',
      dateJoined: DateTime.parse(payload['date_joined']).toLocal(),
      firstName: payload['first_name'] ?? '',
      lastName: payload['last_name'] ?? '',
      isAccountActive: payload['is_active'],
    );
  }
}
