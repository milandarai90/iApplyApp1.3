import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class cancel_booking_request{
  String consultancy_id;
  String branch_id;
  String course_id;
  String classroom_id;

  cancel_booking_request({required this.course_id, required this.consultancy_id, required this.branch_id, required this.classroom_id});

  Map<String,dynamic>toCancelServer(){
    Map<String,dynamic>map ={
      'consultancy_id' : consultancy_id.trim(),
      'branch_id' : branch_id.trim(),
      'course_id' : course_id.trim(),
      'classroom_id' : classroom_id.trim()
    };
    return map;
  }

}
class cancel_booking_response{
final String? message;
final int statusCode;

cancel_booking_response({required this.message,required this.statusCode});

factory cancel_booking_response.fromServer(Map<String,dynamic>json,int statusCode){
  return cancel_booking_response(
      statusCode: statusCode,
      message: json["message"]);
}

}