
import 'package:flutter/material.dart';
import 'package:iapply3/activity/home_activity.dart';
import 'package:iapply3/activity/menu_activity.dart';
import 'package:iapply3/activity/myclass_activity.dart';
import 'package:iapply3/activity/notification_activity.dart';
import 'package:iapply3/activity/profile_activity.dart';

class bottom_navbar_activity extends StatefulWidget{
  final String token;
  const bottom_navbar_activity({super.key,required this.token});
  @override
  State<StatefulWidget> createState() {
   return bottom_navbar_activity_state();
  }
}

class bottom_navbar_activity_state extends State<bottom_navbar_activity>{
  late List<Widget>WidgetList;
 @override
  void initState() {
   super.initState();
   WidgetList = [
     home_activity(token : widget.token),
     myclass_activity(token : widget.token),
     notification_activity(token : widget.token),
     menu_activity(),
     profile_activity()
   ];

  }
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: WidgetList,
      ),
    bottomNavigationBar: Container(

      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.black54,blurRadius: 2,
          offset: Offset(0, -2)
        )]
      ),

      child: BottomNavigationBar(
        onTap: (index){
        setState(() {
          myIndex =index;
        });
        },
          currentIndex: myIndex,
        backgroundColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          unselectedItemColor:Theme.of(context).canvasColor,
          selectedItemColor: Theme.of(context).canvasColor,
          items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined,color: Theme.of(context).canvasColor,),label:  "Home",),
        BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined,color: Theme.of(context).canvasColor),label:  "My Classes"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined,color: Theme.of(context).canvasColor),label:  "Notification"),
        BottomNavigationBarItem(icon: Icon(Icons.menu_rounded,color: Theme.of(context).canvasColor),label:  "Menu"),
        BottomNavigationBarItem(icon: Icon(Icons.person,color: Theme.of(context).canvasColor),label:  "Profile"),

      ]),
    ),
    );
  }

}