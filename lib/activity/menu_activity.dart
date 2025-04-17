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
     body: Center(
       child: Container(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           // crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Icon(Icons.hourglass_bottom_rounded,
               size: 50,
               color: Colors.grey,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("Coming soon...", style: TextStyle(color: Colors.grey)),
             ),
           ],
         ),
       ),
     ),
   );
  }
}