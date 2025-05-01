import 'package:flutter/material.dart';

class after_booking_activity extends StatefulWidget{
  @override
  final String consultancy;
  final String token;
  final String branch;
  final String course;
  final String classes;
  final String cid;
  final String bid;
  final String coid;
  final String clid;

const after_booking_activity({required this.token, required this.course, required this.consultancy, required this.branch, required this.classes, required this.bid, required this.cid , required this.clid , required this.coid});


  State<StatefulWidget> createState() {
    return after_booking_state();
  }

}
class after_booking_state extends State<after_booking_activity>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("coming soon."),
        ),
      )
    );
  }

}