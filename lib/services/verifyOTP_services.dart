import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iApply/models/verifyOTP_model.dart';

class verifyOTP_services{

  Future<verifyOTP_response> otp_verification(verifyOTP_request sendOTP)async {
    final url = "https://iapply.techenfield.com/api/verify_otp";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(sendOTP.otp_toServer()));
    if (response.statusCode == 200) {
      return verifyOTP_response.otpFromServer(
          jsonDecode(response.body), response.statusCode);
    } else if (response.statusCode == 400) {
      return verifyOTP_response.otpFromServer(
          jsonDecode(response.body), response.statusCode);
    } else {
      throw Exception("Something went wrong");
    }
  }

}