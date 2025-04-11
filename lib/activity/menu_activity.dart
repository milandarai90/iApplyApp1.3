import 'package:flutter/material.dart';

class menu_activity extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return menu_activity_state();
  }
}
class menu_activity_state extends State<menu_activity>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Menu",style: TextStyle(color: Theme.of(context).canvasColor),),backgroundColor: Theme.of(context).primaryColor,),
     body: Container(
       child: Center(child: Text("Coming soon...")),
     ),
   );
  }
}