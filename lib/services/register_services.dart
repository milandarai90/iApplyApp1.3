import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iApply/models/register_model.dart';

class register_services{
Future <register_response> register_user(register_request registerData)async{
  final url = "https://iapply.techenfield.com/api/register";
  final uri = Uri.parse(url);
  final response =await http.post(uri,headers: {'Content-Type': 'application/json','Accept' :'application/json'},
      body: jsonEncode(registerData.register_toServer()));
  if(response.statusCode == 200){
    return register_response.register_fromServer(jsonDecode(response.body), response.statusCode);
  }
  else if(response.statusCode == 409){
   return register_response.register_fromServer(jsonDecode(response.body), response.statusCode);
  }else{
    throw Exception("Something went wrong..");

  }
}
}