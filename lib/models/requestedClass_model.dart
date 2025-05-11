class requestedClassModel {
  final String id;
  final String user_id;
  final String consultancy_id;
  final String branch_id;
  final String course_id;
  final String classroom_id;
  final String status;
  final String? created_at;

  final consultancyInfoModel? consultancy;
  final branchInfoModel? branch;
  final courseInfoModel? course;
  final classInfoModel? classroom;

  requestedClassModel({
    required this.id,
    required this.user_id,
    required this.consultancy_id,
    required this.branch_id,
    required this.course_id,
    required this.classroom_id,
    required this.status,
    this.created_at,
    this.consultancy,
    this.branch,
    this.course,
    this.classroom,
  });

  factory requestedClassModel.fromJson(Map<String, dynamic> json) {
    return requestedClassModel(
      id: json["id"].toString(),
      user_id: json["user_id"].toString(),
      consultancy_id: json["consultancy_id"].toString(),
      branch_id: json["branch_id"].toString(),
      course_id: json["course_id"].toString(),
      classroom_id: json["classroom_id"].toString(),
      status: json["status"] ?? '',
      created_at: json["created_at"],
      consultancy: json["booking_request_to_consultancy"] != null
          ? consultancyInfoModel.fromJson(json["booking_request_to_consultancy"])
          : null,
      branch: json["booking_request_to_branch"] != null
          ? branchInfoModel.fromJson(json["booking_request_to_branch"])
          : null,
      course: json["booking_request_to_course"] != null
          ? courseInfoModel.fromJson(json["booking_request_to_course"])
          : null,
      classroom: json["booking_request_to_classroom"] != null
          ? classInfoModel.fromJson(json["booking_request_to_classroom"])
          : null,
    );
  }
}

class consultancyInfoModel {
  final String? id;
  final String? telphone_num;
  final consultancyDetailsModel? consultancy_details;

  consultancyInfoModel({
    this.id,
    this.telphone_num,
    this.consultancy_details,
  });

  factory consultancyInfoModel.fromJson(Map<String, dynamic> json) {
    return consultancyInfoModel(
      id: json["id"].toString(),
      telphone_num: json["telphone_num"],
      consultancy_details: json["consultancy_details"] != null
          ? consultancyDetailsModel.fromJson(json["consultancy_details"])
          : null,
    );
  }
}

class consultancyDetailsModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String u_district;
  final String u_municipality;
  final String u_ward;

  consultancyDetailsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.u_district,
    required this.u_municipality,
    required this.u_ward,
  });

  factory consultancyDetailsModel.fromJson(Map<String, dynamic> json) {
    return consultancyDetailsModel(
      id: json["id"].toString(),
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      u_district: json["u_district"] ?? '',
      u_municipality: json["u_municipality"] ?? '',
      u_ward: json["u_ward"]?.toString() ?? '',
    );
  }
}

class branchInfoModel {
  final String id;
  final String branch_pan;
  final String branch_manager_name;
  final String branch_manager_phone;
  final branchDetailsModel? branch_details;

  branchInfoModel({
    required this.id,
    required this.branch_pan,
    required this.branch_manager_name,
    required this.branch_manager_phone,
    this.branch_details,
  });

  factory branchInfoModel.fromJson(Map<String, dynamic> json) {
    return branchInfoModel(
      id: json["id"].toString(),
      branch_pan: json["branch_pan"] ?? '',
      branch_manager_name: json["branch_manager_name"] ?? '',
      branch_manager_phone: json["branch_manager_phone"] ?? '',
      branch_details: json["user_branch"] != null
          ? branchDetailsModel.fromJson(json["user_branch"])
          : null,
    );
  }
}

class branchDetailsModel {
  final String id;
  final String name;

  branchDetailsModel({required this.id, required this.name});

  factory branchDetailsModel.fromJson(Map<String, dynamic> json) {
    return branchDetailsModel(
      id: json["id"].toString(),
      name: json["name"] ?? '',
    );
  }
}

class courseInfoModel {
  final String id;
  final String course;
  final String created_at;

  courseInfoModel({
    required this.id,
    required this.course,
    required this.created_at,
  });

  factory courseInfoModel.fromJson(Map<String, dynamic> json) {
    return courseInfoModel(
      id: json["id"].toString(),
      course: json["course"] ?? '',
      created_at: json["created_at"] ?? '',
    );
  }
}

class classInfoModel {
  final String id;
  final String class_name;
  final String status;

  classInfoModel({
    required this.id,
    required this.class_name,
    required this.status,
  });

  factory classInfoModel.fromJson(Map<String, dynamic> json) {
    return classInfoModel(
      id: json["id"].toString(),
      class_name: json["class_name"] ?? '',
      status: json["status"] ?? '',
    );
  }
}
