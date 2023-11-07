class UserModel {
  UserModel(
      {required this.email, required this.userName, this.profilePicUrl = ''});

  final String email;
  String userName;
  String profilePicUrl;

  Map<String, dynamic> toDB() {
    Map<String, dynamic> user = {
      "userName": userName,
      "email": email,
      "profilePicUrl": profilePicUrl,
    };
    return user;
  }

  static UserModel fromDB({required dbUser}) {
    return UserModel(
      email: dbUser['email'],
      userName: dbUser['userName'],
      profilePicUrl: dbUser['profilePicUrl'],
    );
  }
}
