class register_response{
final String message;
int statusCode;

register_response({required this.message , required this.statusCode});
factory register_response.register_fromServer(Map<String,dynamic>json,int statusCode){
  return register_response(
      message: json["message"],
      statusCode: statusCode);
}
}


class register_request{
  late  String name;
  late  String email;
  late  String password;
  late  String c_password;

  register_request({required this.name, required this.email, required this.password, required this.c_password});
  Map<String,dynamic>register_toServer(){
    Map<String,dynamic> map ={
    'name': name.trim(),
   'email' : email.trim(),
    'password': password.trim(),
    'c_password': c_password.trim()
    };
    return map;
}
}