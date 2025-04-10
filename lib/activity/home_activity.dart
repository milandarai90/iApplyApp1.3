import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iapply3/models/login_model.dart';

class home_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return home_activity_state();
  }
}
class home_activity_state extends State<home_activity>{
  @override
  void initState() {
    datacheck();
    super.initState();
  }
  List<UserModel>users =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data"),),
      body: ListView.builder(
          itemCount : users.length,
          itemBuilder: (context ,index){
        final userindex = users[index];
               return ListTile(
          title: Text(userindex.name.fullname),
            leading:Text(userindex.gender),
          subtitle: Text(userindex.email),
        );
      }),
    );
  }
  void datacheck() async{
    final uri = 'https://randomuser.me/api/?results=500';
    final url = Uri.parse(uri);
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);
    final result = json["results"] as List<dynamic>;
    final dataMapped = result.map((e){
final name = FullName(
    title: e['name']['title'],
    last: e['name']['last'],
    first: e['name']['first']);
      return UserModel(
        email : e['email'],
        gender : e['gender'],
        name,
      );
    }).toList();
    setState(() {
      users = dataMapped;
    });
  }

}


