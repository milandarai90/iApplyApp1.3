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
final String message;
cancel_booking_response({required this.message});

factory cancel_booking_response.fromServer(Map<String,dynamic>json){
  return cancel_booking_response(message: json["message"]);
}

}