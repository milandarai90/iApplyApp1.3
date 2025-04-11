import 'package:flutter/material.dart';

class notification_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return notification_activity_state();
  }
}
class notification_activity_state extends State<notification_activity>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification",style: TextStyle(color: Theme.of(context).canvasColor),),backgroundColor: Theme.of(context).primaryColor,),
      body: Container(
        child: Center(child: Text("Coming soon...")),
      ),
    );
  }
}