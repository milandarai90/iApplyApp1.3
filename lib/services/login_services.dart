import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iapply3/models/login_model.dart';

class login_api_services{
  Future<login_response> login (login_request requestFromServer)async{
    final url = "https://iapply.techenfield.com/api/login";
    final uri = Uri.parse(url);
    // final response =await http.post(uri,body: requestFromServer.toServer());
    final response = await http.post(uri, headers: {'Accept': 'application/json'},
      body: requestFromServer.toServer(),
    );
    if(response.statusCode == 200 || response.statusCode ==400){
      return login_response.fromServer(json.decode(response.body));
    }else if (response.statusCode == 400 || response.statusCode == 401) {
      return login_response.fromServer(json.decode(response.body));
      }
    else
      {
        throw Exception('failed to login');
      }
  }

}