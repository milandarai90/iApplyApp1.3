class requestedClassModel{
  final String? id;
  final String? user_id;
  final String? consultancy_id;
  final String? branch_id;
  final String? course_id;
  final String? classroom_id;
  final String? status;
  final String? created_at;
  final List<consultancyInfoModel> booking_request_to_consultancy;
  final List<branchInfoModel>booking_request_to_branch;
  final List<courseInfoModel>booking_request_to_course;
  final List<classInfoModel> booking_request_to_classroom;

  requestedClassModel(this.booking_request_to_consultancy, this.booking_request_to_branch, this.booking_request_to_course, this.booking_request_to_classroom, {
    required this.id,
    required this.user_id,
    required this.consultancy_id,
    required this.branch_id,
    required this.course_id,
    required this.classroom_id,
    required this.status,
    required this.created_at,
    });

}

class consultancyInfoModel {
  final String? id;
  final String? telphone_num;
  final List<consultancyDetailsModel> consultancyAllData;

  consultancyInfoModel(this.consultancyAllData, {required this.id, required this.telphone_num});

}


class consultancyDetailsModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? u_district;
  final String? u_municipality;
  final String? u_ward;

  consultancyDetailsModel({required this.id, required this.name, required this.email, required this.phone, required this.u_district, required this.u_municipality, required this.u_ward});
}

class classInfoModel {
  final String? id;
  final String? class_name;
  final String? status;

  classInfoModel({required this.id, required this.class_name, required this.status});

}


class courseInfoModel {
  final String id;
  final String course;
  final String created_at;

  courseInfoModel({required this.id, required this.course, required this.created_at});


}

class branchInfoModel {
  final String id;
  final String branch_pan;
  final String branch_manager_name;
  final String branch_manager_phone;
  final List<branchDetailsModel> user_branch;

  branchInfoModel(this.user_branch, {required this.id, required this.branch_pan, required this.branch_manager_name, required this.branch_manager_phone});
}

class branchDetailsModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  branchDetailsModel({required this.id, required this.name, required this.email, required this.phone});

}
