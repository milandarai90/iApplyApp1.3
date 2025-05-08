import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iApply/models/cancel_booking_model.dart';

class cancel_booking_services{
  Future<cancel_booking_response> cancel_booking(cancel_booking_request requestCancelBooking,String token)async{
    final url = "https://iapply.techenfield.com/api/cancelBooking/?consultancy_id=${requestCancelBooking.consultancy_id}&branch_id=${requestCancelBooking.branch_id}&course_id=${requestCancelBooking.course_id}&classroom_id=${requestCancelBooking.classroom_id}";
    final uri = Uri.parse(url);
    final response =await http.post(uri, headers: {
      'Authorization' : "Bearer $token",
      'Accept' : "application/json",
      'Content-Type' : "application/json"
    },
        body: jsonEncode(requestCancelBooking.toCancelServer())
    );
    if(response.statusCode == 200){
      return cancel_booking_response.fromServer(jsonDecode(response.body),response.statusCode);
    }else if(response.statusCode == 400){
      return cancel_booking_response.fromServer(jsonDecode(response.body),response.statusCode);
    }
    else {
      throw Exception("Failed to cancel booking.");
    }
  }
}