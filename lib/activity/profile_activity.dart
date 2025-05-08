import 'package:flutter/material.dart';
import 'package:iApply/activity/login_activity.dart';

class profile_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return profile_activity_state();
  }
}
class profile_activity_state extends State<profile_activity>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Profile",style: TextStyle(color: Theme.of(context).canvasColor),),backgroundColor: Theme.of(context).primaryColor,),
    body: Container(
      color: Theme.of(context).canvasColor,
      child: Center(child: ElevatedButton(onPressed:(){
        
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => login_activity()),(route) =>false);
        
      },style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
          child: Text("Logout",style: TextStyle(color: Theme.of(context).canvasColor),))),
    ),
  );
  }
}