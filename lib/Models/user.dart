class UserModel{

  UserModel({
    required this.email,
    required this.userName,
  });

  final String email;
  final String userName;

  Map<String, dynamic>toDB(){
    Map<String, dynamic> user = {
      "userName" : userName,
      "email": email
    };
    return user;
  }
}