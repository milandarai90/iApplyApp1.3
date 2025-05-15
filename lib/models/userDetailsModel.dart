import 'dart:convert';

class userDetailsModel{
  final String? success;
  final String? message;
  final userDataModel? data;

  userDetailsModel({required this.success, required this.message, required this.data});
  factory userDetailsModel.fromServer(Map<String,dynamic>json){
    return userDetailsModel(
    success: json["success"]?.toString() ?? "",
    message: json["message"]?.toString() ?? "",
    data: json["data"] != null ? userDataModel.fromServer(json["data"]) : null
    );
  }
}

class userDataModel{
  final String id;
  final String name;
  final String email;
  final String phone;
  final String u_district;
  final String u_municipality;
  final String u_ward;
  final profileImageModel? profileImage;

  userDataModel({required this.id, required this.name, required this.email, required this.phone, required this.u_district, required this.u_municipality, required this.u_ward, required this.profileImage});

  factory userDataModel.fromServer(Map<String,dynamic>json){
    return userDataModel(
        id: json["id"]?.toString() ?? "" ,
        name: json["name"]?.toString() ?? "",
        email: json["email"]?.toString() ?? "",
        phone: json["phone"]?.toString() ?? "" ,
        u_district: json["u_district"]?.toString() ?? "",
        u_municipality: json["u_municipality"]?.toString() ?? "",
        u_ward: json["u_ward"]?.toString() ?? "",
        profileImage: json["user_to_profile_image"] != null ? profileImageModel.fromServer(json["user_to_profile_image"])
            : null
    );
  }
}
class profileImageModel{
  final String? id;
  final String? user_id;
  final String? image_path;

  profileImageModel({required this.id, required this.user_id, required this.image_path});
  factory profileImageModel.fromServer(Map<String,dynamic>json){
    return profileImageModel(
        id: json["id"]?.toString() ??"",
      user_id: json["user_id"]?.toString() ?? "",
      image_path: json["image_path"]?.toString() ?? ""
    );
  }
}