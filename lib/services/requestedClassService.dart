import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iApply/models/requestedClass_model.dart';

class requestedClassServices {
  Future<List<requestedClassModel>> requestedClasses(String token) async {
    final url = "https://iapply.techenfield.com/api/requested-booking";
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    // print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> result = json["result"] ?? [];

      return result
          .map<requestedClassModel>((item) => requestedClassModel.fromJson(item))
          .toList();
    }

    throw Exception("Something went wrong: ${response.statusCode}");
  }
}
