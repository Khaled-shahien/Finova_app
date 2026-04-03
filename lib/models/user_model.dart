/// User profile document used by Finova settings.
class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.isDarkMode,
    required this.currency,
  });

  final String uid;
  final String email;
  final String displayName;
  final bool isDarkMode;
  final String currency;

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: (map['email'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? 'Finova User',
      isDarkMode: (map['isDarkMode'] as bool?) ?? false,
      currency: (map['currency'] as String?) ?? 'USD',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'isDarkMode': isDarkMode,
      'currency': currency,
    };
  }
}
