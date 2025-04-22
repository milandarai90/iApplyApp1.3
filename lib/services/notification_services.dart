import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notification_model.dart';

class notification_services{
Future<List<notification_model>>notification(String token)async{
  final url = 'https://iapply.techenfield.com/api/notifications/';
  final uri =Uri.parse(url);
  final response =await http.get(uri , headers:{
    "Authorization": "Bearer $token",
    "Accept": "application/json",
    "Content-Type": "application/json"
  });
  if(response.statusCode == 200){
    final body = response.body;
    final json = jsonDecode(body);
   final List<dynamic> notification_data= json['notifications'] ?? [];
   // print(notification_data);
   final mapped_notification = notification_data.map<notification_model>((e){
     return notification_model(
         id: e['id'].toString() ?? "",
         notifications: e['notifications'],
         created_at: e['created_at'].toString() ?? "");
   }).toList();
    return mapped_notification;
  }else{
    throw Exception("Something went wrong");
  }
}
}