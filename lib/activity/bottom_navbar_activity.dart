
import 'package:flutter/material.dart';
import 'package:iapply3/activity/home_activity.dart';
import 'package:iapply3/activity/menu_activity.dart';
import 'package:iapply3/activity/myclass_activity.dart';
import 'package:iapply3/activity/notification_activity.dart';
import 'package:iapply3/activity/profile_activity.dart';

class bottom_navbar_activity extends StatefulWidget{
  const bottom_navbar_activity({super.key});
  @override
  State<StatefulWidget> createState() {
   return bottom_navbar_activity_state();
  }
}

class bottom_navbar_activity_state extends State<bottom_navbar_activity>{
  List<Widget>WidgetList = [
    home_activity(),
    myclass_activity(),
    notification_activity(),
    menu_activity(),
    profile_activity()
  ];
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: WidgetList,
      ),
    bottomNavigationBar: Container(

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
        BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined,color: Theme.of(context).canvasColor),label:  "Users"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined,color: Theme.of(context).canvasColor),label:  "Notification"),
        BottomNavigationBarItem(icon: Icon(Icons.menu,color: Theme.of(context).canvasColor),label:  "Menu"),
        BottomNavigationBarItem(icon: Icon(Icons.person,color: Theme.of(context).canvasColor),label:  "Profile"),

      ]),
    ),
    );
  }

}