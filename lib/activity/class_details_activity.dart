import 'package:flutter/material.dart';

class class_details_acitivty extends StatefulWidget{
  final String token;
  final String consultancy_id;
  final String branch_id;
  final String course_id;
  final String class_id;
  final String class_name;
  final String students_number;
  final String seat_number;
  final String status;
  final String start_time;
  final String end_time;
  final String start_date;
  final String end_date;

  const class_details_acitivty({super.key, required this.token, required this.consultancy_id, required this.branch_id, required this.course_id, required this.class_id, required this.class_name, required this.students_number, required this.seat_number, required this.status, required this.start_time, required this.end_time, required this.start_date, required this.end_date});

  @override
  State<StatefulWidget> createState() {
    return class_details_state();
  }
}
class class_details_state extends State<class_details_acitivty>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(backgroundColor: Theme.of(context).primaryColor,
       iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
       title: Text("Details for ${widget.class_name}",style: TextStyle(color: Theme.of(context).canvasColor),),),
     body: Container(
       color: Theme.of(context).canvasColor,
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       child: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Container(
               height:180,
               width:  MediaQuery.of(context).size.width,
               color: Colors.red,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                       child: Center(
                           child: Text("23/50",style: TextStyle(fontSize: 30,color: Theme.of(context).primaryColor),)),
                       height: 120,
                       width: 120,
                       decoration: BoxDecoration(
                         border:  Border.all(
                           width: 5,
                           color: Theme.of(context).primaryColor
                         ),
                         color: Theme.of(context).canvasColor,
                         borderRadius: BorderRadius.circular(200)
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Status: available",style: TextStyle(fontSize: 16),),
                   ),
                 ],
               )
               ),
             ),
           Container(

           )
         ],
       ) ,
     ),
   );
  }
}