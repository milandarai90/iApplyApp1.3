import 'package:http/http.dart' as http;
import 'package:iapply3/models/booking_model.dart';
import 'dart:convert';

class booking_services{
 Future<booking_response> book_services (booking_request request_bookingFromServer,String token)async{
   final url ="https://iapply.techenfield.com/api/book?consultancy_id=${request_bookingFromServer.consultancy_id}&branch_id=${request_bookingFromServer.branch_id}&course_id=${request_bookingFromServer.course_id}&classroom_id=${request_bookingFromServer.classroom_id}";
   final uri = Uri.parse(url);
   final response = await http.post(uri, headers: {
     "Authorization": "Bearer $token",
     "Accept": "application/json",
     "Content-Type": "application/json"}
       ,body:jsonEncode(request_bookingFromServer.to_bookingServer()));
   if(response.statusCode == 200){
     return booking_response.from_bookingServer(json.decode(response.body),response.statusCode);
   }else if(response.statusCode == 400 || response.statusCode == 401){
     return booking_response.from_bookingServer(json.decode(response.body),response.statusCode);
   }
else{
  throw Exception('Failed to book.');
   }
 }

}