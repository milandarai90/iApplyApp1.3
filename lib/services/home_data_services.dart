import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iApply/models/consultancy_details_model.dart';

class consultancy_data_services {

  Future<List<Consultancy_details_model>> consultancy_details(String token) async {
    final url = "https://iapply.techenfield.com/api/home";
    final uri = Uri.parse(url);
    final response_consultancy_data = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    if (response_consultancy_data.statusCode == 200) {
      final body = response_consultancy_data.body;
      final json = jsonDecode(body);
      final List<dynamic> result = json["consultancy_details"] ?? [];
      final mappedData = result.map<Consultancy_details_model>((e) {

        final List<dynamic> branchList = e["branch_details"] ?? [];
        final List<Branch_details_model> branches = branchList.map<Branch_details_model>((branch) {

          final List<dynamic> courseList = branch["course_details"] ?? [];

          final List<Course_details_model> courses = courseList.map<Course_details_model>((course) {

            final List<dynamic> classList = course["class_details"] ?? [];
            final List<Class_details_model> classes = classList.map<Class_details_model>((classMap) {
              return Class_details_model(
                id: classMap["id"]?.toString() ?? '',
                class_name: classMap["class_name"] ?? '',
                students_number: (classMap["students_number"] is int)
                    ? classMap["students_number"].toString()
                    : classMap["students_number"] ?? '',
                seat_numbers: (classMap["seat_numbers"] is int)
                    ? classMap["seat_numbers"].toString()
                    : classMap["seat_numbers"] ?? '',
                status: classMap["status"] ?? '',
                start_time: classMap["start_time"] ?? '',
                end_time: classMap["end_time"] ?? '',
                start_date: classMap["start_date"] ?? '',
                end_date: classMap["end_date"] ?? '',
              );
            }).toList();
            return Course_details_model(
              classes,
              id: course["id"]?.toString() ?? '',
              course_title: course["course_title"] ?? '',
            );
          }).toList();
          return Branch_details_model(
            courses,
            id: branch["id"]?.toString() ?? '',
            name: branch["name"] ?? '',
            email: branch["email"] ?? '',
            phone: branch["phone"] ?? '',
            u_district: branch["u_district"] ?? '',
            u_municipality: branch["u_municipality"] ?? '',
            u_ward: branch["u_ward"] ?? '',
            photo: branch["photo"] ?? '',
          );
        }).toList();
        return Consultancy_details_model(
          branches,
          id: e["id"]?.toString() ?? '',
          name: e["name"] ?? '',
          email: e["email"] ?? '',
          phone: e["phone"] ?? '',
          u_district: e["u_district"] ?? '',
          u_municipality: e["u_municipality"] ?? '',
          u_ward: e["u_ward"] ?? '',
          photo: e["photo"] ?? '',
        );
      }).toList();
      return mappedData;
          // .take(5).toList();
    } else {
      throw Exception("Something went wrong. Status code: ${response_consultancy_data.statusCode}");
    }
  }
}
