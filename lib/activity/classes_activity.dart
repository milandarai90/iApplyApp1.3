import 'package:flutter/material.dart';

class classes_activity extends StatefulWidget{
  final String consultancy_id;
  final String token;
  final String branch_id;
  final String course_id;
  final String course_name;

  const classes_activity({super.key, required this.consultancy_id, required this.token, required this.branch_id, required this.course_id, required this.course_name});

  @override
  State<StatefulWidget> createState() {
    return classes_state();
  }
}
class classes_state extends State<classes_activity>{
  @override
  Widget build(BuildContext context) {
  return Scaffold();
  }
}