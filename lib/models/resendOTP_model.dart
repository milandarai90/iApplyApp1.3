class otpResendResponse{
  final String? message;
  int statusCode;

  otpResendResponse({required this.statusCode , required this.message});

  factory otpResendResponse.otpResendFromServer(Map<String,dynamic> json, int statusCode){
    return otpResendResponse(
        statusCode: statusCode,
        message: json["message"]);
  }

}

class otpResendRequest{
  late String email;

  otpResendRequest({required this.email});

  Map<String,dynamic>otpResendToServer(){
    Map<String,dynamic> map ={
      'email' : email.trim()
    };
    return map;
  }
}