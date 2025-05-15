import 'package:iApply/models/userDetailsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class userDetailsServices{

  Future<List<userDetailsModel>> userDetails(String token)async{

    final url = "https://iapply.techenfield.com/api/user-detail";
    final uri = Uri.parse(url);
    final request =await http.get(uri,headers: {
      'Authorization' :'Bearer $token',
      'Content-Type' : 'application/json',
      'Accept' : 'application/json'
    });
    if(request.statusCode == 200){
      final body = request.body;
      final json = jsonDecode(body);
      final List<dynamic> result = json["data"] ?? [];

      return result.map<userDetailsModel>((ud)=>userDetailsModel.fromServer(ud)).toList();
    }

    throw Exception("Something went wrong");
  }

}