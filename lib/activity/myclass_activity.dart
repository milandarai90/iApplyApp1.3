import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/login_model.dart';

class myclass_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return myclass_activity_state();
  }
}
class myclass_activity_state extends State<myclass_activity>{
  @override
  void initState() {
    datacheck();
    super.initState();
  }
  List<UserModel>users =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Testing Users",style: TextStyle(color: Theme.of(context).canvasColor))),
      body: ListView.builder(
          itemCount : users.length,
          itemBuilder: (context ,index){
        final userindex = users[index];
               return ListTile(
          title: Text(userindex.name.fullname),
            leading:CircleAvatar(child: Text("${index+1}")),
          subtitle: Text(userindex.email),
        );
      }),
    );
  }
  void datacheck() async{
    final uri = 'https://randomuser.me/api/?results=50';
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



