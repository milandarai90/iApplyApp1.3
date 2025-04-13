import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/general_country_model.dart';


class general_country_services{
  Future<List<General_country_model>>general_country_data(String token)async{
  final url = "https://iapply.techenfield.com/api/home/";
  final uri = Uri.parse(url);
  final general_country_services_response =await http.get(uri, headers: {
    "Authorization": "Bearer $token",
    "Accept": "application/json",
    "Content-Type": "application/json"
  });
  if(general_country_services_response.statusCode == 200){
    final body = general_country_services_response.body;
    final json = jsonDecode(body);
    final List<dynamic> country_result = json["general_country"] ?? [];
    final mapped_country_data = country_result.map<General_country_model>((e){
      final List<dynamic> country_guidelines_data = e["guidelines"]??[];

      final mapped_guidelines = country_guidelines_data.map<Guidelines_model>((g){

        return Guidelines_model(
            id: g["id"]?.toString() ?? "",
            Guidelines: g["Guidelines"] ?? ""
        );

      }).toList();
      return General_country_model(
          id: e["id"]?.toString() ?? "",
          country: e["country"]?? "",
          map: e["map"]?? '',
        guidelines_data: mapped_guidelines,
      );
    }).toList();
    return mapped_country_data;
  }
  else{
    throw Exception("Something went wrong");
  }
}
}