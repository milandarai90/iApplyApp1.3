import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iapply3/models/consultancy_details_model.dart';

class consultancy_data_services {
  Future<List<Consultancy_details_model>>consultancy_details() async {
    final url = "https://iapply.techenfield.com/api/home";
    final uri = Uri.parse(url);
    final response_consultancy_data = await http.get(uri,headers:{"Authorization": "Bearer YOUR_TOKEN", "Accept" : "application/json", "Content-Type" : "application/json"});
    if(response_consultancy_data.statusCode == 200){
      print(response_consultancy_data.statusCode);
      final body = response_consultancy_data.body;
      final json = jsonDecode(body);
      final result= json["consultancy_details"] as List<dynamic>;
      final mapped_data = result.map<Consultancy_details_model>((e){
        final List<Branch_details_model> branches = (e["branch_details"] as List<dynamic>??[]).map((branch){
          final List<Course_details_model>courses = (branch["course_details"] as List<dynamic>??[]).map((course){
            final List<Class_details_model>classes =(course["class_details"] as List<dynamic>??[]).map((class_map){
              return Class_details_model(
                  id: class_map["id"].toString(),
                  class_name: class_map["class_name"],
                  students_number: class_map["students_number"],
                  seat_number: class_map["seat_number"],
                  status: class_map["status"],
                  start_time: class_map["start_time"],
                  end_time: class_map["end_time"],
                  start_date: class_map["start_date"],
                  end_date: class_map["end_date"]);
            }).toList();
            return Course_details_model(
              id: course["id"].toString(),
              course_title: course["course_title"],
              classes,
            );
          }).toList();
          return Branch_details_model(
              courses,
              id: branch["id"].toString(),
              name: branch["name"],
              phone: branch["phone"],
              u_district: branch["u_district"],
              u_municipaity: branch["u_municipaity"],
              u_ward: branch["u_ward"],
              photo: branch["photo"],);
        }).toList();
        return Consultancy_details_model(
          branches,
          id: e["id"].toString(),
          name: e["name"],
          phone: e["phone"],
          photo: e["photo"],
          u_district: e["u_district"],
          u_municipaity: e["u_municipality"],
          u_ward:e["u_ward"],
        );
      }).toList();
      return mapped_data;
    }else{
      // print("Failed. Status Code: ${response_consultancy_data.statusCode}");
      throw Exception("Something went wrong");
    }
  }
}