import 'dart:convert';

class verifyOTP_response{

  final String? message;
  int statusCode;

  verifyOTP_response({required this.message , required this.statusCode});

  factory verifyOTP_response.otpFromServer(Map<String,dynamic>json , int statusCode){
    return verifyOTP_response(
        message: json["message"],
        statusCode: statusCode);
  }

}
class verifyOTP_request{
  late String name;
  late String email;
  late String password;
  late String otp;
  late String c_password;

  verifyOTP_request({required this.c_password, required this.name , required this.password , required this.email , required this.otp});

  Map<String,dynamic>otp_toServer(){
    Map<String,dynamic> map ={
      'name' : name.trim(),
      'email' : email.trim(),
      'password' : password.trim(),
      'otp' : otp.trim(),
      'c_password' : c_password.trim()
    };
    return map;
  }
}