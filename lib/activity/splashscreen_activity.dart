import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class splashscreen_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return splashscreen_state();
  }

}
class splashscreen_state extends State<splashscreen_activity>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,

      ),
    );
  }

}