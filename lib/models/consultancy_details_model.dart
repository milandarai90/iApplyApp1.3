class Consultancy_details_model{
 late final String id;
 late final String name;
 late final String email;
 final String? phone;
 final String? u_district;
 final String? u_municipality;
 final String? u_ward;
 final String? photo;
 final List<Branch_details_model> branch_details;

  Consultancy_details_model(this.branch_details, {required this.id, required this.name, required this.email, this.phone,  this.u_district,  this.u_municipality,  this.u_ward,  this.photo});
  }

class Branch_details_model{
   final String? id;
   final String? name;
   final String? email;
  final String? phone;
  final String? u_district;
  final String? u_municipality;
  final String? u_ward;
  final String? photo;
  final List<Course_details_model> course_details;

  Branch_details_model(this.course_details, {required this.id, required this.email, required this.name, required this.phone, required this.u_district, required this.u_municipality, required this.u_ward, required this.photo});
}

class Course_details_model{
  final String? id;
  final String? course_title;
  final List<Class_details_model> class_details;

  Course_details_model(this.class_details, { this.id,this.course_title});
}

class Class_details_model{
  final String? id;
  final String? class_name;
  final String? students_number;
  final String? seat_number;
  final String? status;
  final String? start_time;
  final String? end_time;
  final String? start_date;
  final String? end_date;

  Class_details_model({required this.id, required this.class_name, required this.students_number, required this.seat_number, required this.status, required this.start_time, required this.end_time, required this.start_date, required this.end_date});
}