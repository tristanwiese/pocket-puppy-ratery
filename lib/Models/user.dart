class UserModel {
  UserModel({
    required this.email,
    required this.userName,
    required this.role,
    this.profilePicUrl = '',
  });

  final String email;
  String userName;
  String profilePicUrl;
  String role;

  Map<String, dynamic> toDB() {
    Map<String, dynamic> user = {
      "role": role,
      "userName": userName,
      "email": email,
      "profilePicUrl": profilePicUrl,
    };
    return user;
  }

  static UserModel fromDB({required dbUser}) {
    return UserModel(
      role: dbUser['role'],
      email: dbUser['email'],
      userName: dbUser['userName'],
      profilePicUrl: dbUser['profilePicUrl'],
    );
  }
}
