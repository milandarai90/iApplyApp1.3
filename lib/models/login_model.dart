class UserModel{
  final FullName name;
  late final String email;
  late final String gender;
  // late final String location;

  UserModel(this.name, {required this.gender ,  required this.email});
}
class FullName{
  final String title;
  final String last;
  final String first;

  FullName({required this.title, required this.last, required this.first});
  String get fullname => "$title $first $last";
}






class login_response{
  final String token;
  final String email;

  login_response({required this.token, required this.email});

  factory login_response.fromServer(Map<String,dynamic>json){
return login_response(token: json["token"] != null ? json["token"] : "", email: json['email'] != null ? json['email'] : "");
//     return login_response(
//       token: json['token'] ?? '',
//       email: json['email'] ?? '',
//     );
  }
}

class login_request{
   String email;
   String password;

  login_request({required this.email, required this.password});
  Map<String, dynamic>toServer(){
    Map<String,dynamic> map ={
      'email' : email.trim(),
      'password' : password.trim(),
    };
    return map;
  }

}
