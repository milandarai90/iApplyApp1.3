import 'package:iApply/models/requestedClass_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class requestedDataServices{
  Future<List<requestedClassModel>>requestedClasses(String token)async{
    final url = "https://iapply.techenfield.com/api/requested-booking";
    final uri = Uri.parse(url);
    final response = await http.get(uri , headers: {"Authorization" : "Bearer $token","Content-Type" : "application/json" ,"Accept" : "application/json" });

    if(response.statusCode == 200){
      final body = response.body;
      final json = jsonDecode(body);
      final List<dynamic> result = json["result"] ?? [];

      final List<requestedClassModel> requestClassData = result.map<requestedClassModel>((rcd){

        final List<dynamic> classInfo = json["booking_request_to_classroom"] ?? [];
        final List<classInfoModel> classes = classInfo.map<classInfoModel>((cli){
          return classInfoModel(
              id: cli["id"]?.toString() ?? "",
              class_name: cli["class_name"] ?? "",
              status: cli["status"] ?? "");
        }).toList();

        final List<dynamic> courseInfo = json ["booking_request_to_course"] ?? [];
        final List <courseInfoModel> course = courseInfo.map<courseInfoModel>((cri){
          return courseInfoModel(
              id: cri["id"]?.toString() ?? "",
              course: cri["course"] ?? "",
              created_at: cri["created_at"]?.toString() ?? "");
        }).toList();

        final List<dynamic> branchInfo = json["booking_request_to_branch"] ?? [];
        final List<branchInfoModel> branch = branchInfo.map<branchInfoModel>((bi){
          final List<dynamic> branchDetails = json["user_branch"] ?? [];
          final List<branchDetailsModel> branchName = branchDetails.map<branchDetailsModel>((bn){
            return branchDetailsModel(
                id: bn["id"]?.toString() ?? "",
                name: bn["name"] ?? "",
                email: bn["email"]?.toString() ?? "",
                phone: bn["phone"]?.toString() ?? "");
          }).toList();
          return branchInfoModel(
              branchName,
              id: bi["id"]?.toString() ?? "",
              branch_pan: bi["branch_pan"]?.toString() ?? "",
              branch_manager_name: bi["branch_manager_name"] ?? "",
              branch_manager_phone:  bi["branch_manager_phone"]?.toString() ?? "");
        }).toList();

        final List<dynamic>consultancyInfo = json["booking_request_to_consultancy"] ?? [];
        final List<consultancyInfoModel>consultancy = consultancyInfo.map<consultancyInfoModel>((ci){
          final List<dynamic> consultancyDetails = json["consultancy_details"] ?? [];
          final List <consultancyDetailsModel> consultancyName = consultancyDetails.map<consultancyDetailsModel>((cn){
            return consultancyDetailsModel(
                id: cn["id"]?.toString() ?? '',
                name: cn["name"] ?? '',
                email: cn["email"]?.toString() ?? '',
                phone: cn["phone"]?.toString() ?? '',
                u_district: cn["u_district"] ?? '',
                u_municipality: cn["u_municipality"] ?? '',
                u_ward: cn["u_ward"]?.toString() ?? '');
          }).toList();
          return consultancyInfoModel(
              consultancyName,
              id: ci["id"]?.toString(),
              telphone_num: ci["telphone_num"]?.toString());
        }).toList();
        return requestedClassModel(
            consultancy,
            branch,
            course,
            classes,
            id: rcd["id"]?.toString() ?? "",
            user_id: rcd["user_id"]?.toString() ?? "",
            consultancy_id: rcd["consultancy_id"]?.toString() ?? "",
            branch_id: rcd["branch_id"]?.toString() ?? "",
            course_id: rcd["course_id"]?.toString()?? "",
            classroom_id: rcd["classroom_id"]?.toString() ?? "",
            status: rcd["status"] ?? "",
            created_at: rcd["created_at"]?.toString());
      }).toList();
      return requestClassData;
    }
    throw Exception("Something went wrong");
}
}