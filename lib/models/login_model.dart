
class login_response{
  final String? token;
  final String? message;
  // final String message;

  login_response({ this.token,   this.message , });

  factory login_response.fromServer(Map<String,dynamic>json){
    return login_response(
      token: json['token'],
      message: json['message'],
    );
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
