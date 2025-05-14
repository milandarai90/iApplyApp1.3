import 'dart:convert';

import 'package:iApply/models/avatarChangeModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';

class avatarChangeServices{
  Future<avatarChangeResponse> changeAvatar(avatarChangeRequest avatarRequest,String token)async{
    var url = "https://iapply.techenfield.com/api/change-avatar";
    var uri = Uri.parse(url);

    if(!avatarRequest.avatar.existsSync()){
      throw Exception("Selected file doesnot exist");
    }

    var request = http.MultipartRequest('POST',uri);
    request.headers.addAll({
      'Authorization' : "Bearer $token",
    });
    // print(request.headers);
    request.files.add(await http.MultipartFile.fromPath('avatar',avatarRequest.avatar.path,filename: basename(avatarRequest.avatar.path) ));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    // print(responseBody);
    if(response.statusCode == 200 || response.statusCode == 300 ){
      return avatarChangeResponse.fromAvatarServer(
      jsonDecode(responseBody), response.statusCode);
    }else{
      throw Exception("Something went wrong");
    }

  }
}