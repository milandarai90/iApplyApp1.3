import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iapply3/models/resendOTP_model.dart';

class otpResendServices{

  Future<otpResendResponse> otp(otpResendRequest otpRequested)async{
    final uri = "https://iapply.techenfield.com/api/resend_otp";
    final url = Uri.parse(uri);
    final response =await http.post(url ,
        headers: {
      "Content-Type" : "application/json",
          "Accept" : "application/json"
        },
    body: jsonEncode(otpRequested.otpResendToServer()));
    if(response.statusCode == 200){
      return otpResendResponse.otpResendFromServer(jsonDecode(response.body), response.statusCode);
    }
    else{
      throw Exception("Something went wrong..");
    }
  }

}