import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iapply3/activity/home_activity.dart';
import 'package:iapply3/activity/login_activity.dart';


class splashscreen_activity extends StatefulWidget{
  const splashscreen_activity({super.key});

  @override
  State<StatefulWidget> createState() {
    return splashscreen_state();
  }

}
class splashscreen_state extends State<splashscreen_activity>{

  @override
  void initState() {
    super.initState();
    if(!mounted) return;
    Timer(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login_activity()));
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          child: Center(
              child: SizedBox(
                width: double.maxFinite,
                  height: double.maxFinite,
                  child: Image.asset("assets/images/iapply_logo.png"))
          ),
        ),
      ),
    );
  }

}