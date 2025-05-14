import 'dart:io';

import 'package:flutter/foundation.dart';

class avatarChangeResponse{
  final String message;
  int statusCode;

  avatarChangeResponse({required this.message,required this.statusCode});

  factory avatarChangeResponse.fromAvatarServer(Map<String,dynamic>json , int statusCode){
    return avatarChangeResponse(
        message: json["message"],
        statusCode: statusCode,
    );
  }
}
class avatarChangeRequest{
  final File avatar;

  avatarChangeRequest({required this.avatar});

}