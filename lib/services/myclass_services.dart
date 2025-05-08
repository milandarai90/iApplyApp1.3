import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iApply/models/myclass_model.dart';
class myclass_services{

 Future<List<myclass_model>?> myclass_data (String token)async{
   final url = "https://iapply.techenfield.com/api/AfterBookingPage/";
   final uri = Uri.parse(url);
   final response = await http.get(uri , headers: {
     "Authorization" : "Bearer $token",
     "Accept" : "application/json",
     "Content-Type" : "application/json"
   });
   if(response.statusCode == 200){
     final body = response.body;
     // print(response.body);
     final json = jsonDecode(body);
     final List<dynamic> myclass_data = json["data"] ?? [];
     final mapped_myclass_data = myclass_data.map<myclass_model>((e){
       return myclass_model(
           consultancy: e['consultancy_name'],
           branch: e['branch_name'],
           course: e['course_name'],
           classroom: e['classroom_name'],
         status: e['status']
       );
     }).toList();
     return mapped_myclass_data;
   }
   else{
     throw Exception("Something went wrong.");
   }

 }
}