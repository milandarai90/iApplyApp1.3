class booking_response{
  final int? statusCode;
  final String? message;
  booking_response({ required this.statusCode,required this.message});

  factory booking_response.from_bookingServer(Map<String,dynamic>json,int statusCode){
    return booking_response(
      statusCode: statusCode,
        message: json['message']);
  }
}

class booking_request{

  // final String token;
  final String consultancy_id;
  final String branch_id;
  final String course_id;
  final String classroom_id;

  booking_request({ required this.consultancy_id, required this.branch_id, required this.course_id, required this.classroom_id});
  Map<String,dynamic>to_bookingServer(){
    Map<String,dynamic>map={
      // 'token' : token.trim(),
      'consultancy_id' : consultancy_id.trim(),
      'branch_id': branch_id.trim(),
      'course_id': course_id.trim(),
      'classroom_id' : classroom_id.trim(),
    };
    return map;
  }

}