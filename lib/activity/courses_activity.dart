import 'package:flutter/material.dart';
import 'package:iapply3/services/general_country_services.dart';
import 'package:iapply3/services/home_data_services.dart';

import '../models/consultancy_details_model.dart';

class courses_activity extends StatefulWidget{
  final String token;
  final String branch;
  final String branch_id;
  final String consultancy_id;
  final String consultancy;

  const courses_activity({required this.branch, required this.token, required this.branch_id, required this.consultancy_id, required this.consultancy});
  @override
  State<StatefulWidget> createState() {
  return course_state();
  }
}

class course_state extends State<courses_activity>{
  @override
  void initState() {
   fetch_courses_data();
    super.initState();
  }
  bool isLoading=true;
  List<Course_details_model>courses_list = [];
  Future<void> fetch_courses_data()async{
    try{
      final consultancy_services = consultancy_data_services();
      final response_consultancy =await consultancy_services.consultancy_details(widget.token);
      final match_consultancy_id = response_consultancy.firstWhere((consultancy) => consultancy.id == widget.consultancy_id);
      final branch_list = match_consultancy_id.branch_details;
      final match_branch_id = branch_list.firstWhere((branch)=>branch.id == widget.branch_id);
      setState(() {
        courses_list = match_branch_id.course_details;
        isLoading= false;
      });
    }
        catch(e){
setState(() {
  isLoading = false;
});
        }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(backgroundColor:Theme.of(context).primaryColor,iconTheme: IconThemeData(color: Theme.of(context).canvasColor) ,title: Text("Courses for ${widget.branch}",style: TextStyle(color: Theme.of(context).canvasColor),)),
     body: Container(
       child: isLoading ?
       Center(
         child: CircularProgressIndicator(),
       ): courses_list.isEmpty ?
       Center(
         child:Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.sentiment_very_dissatisfied_rounded,
             size: 50,
                 color: Colors.grey,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text("No courses found for ${widget.branch}", style: TextStyle(color: Colors.grey),),
             )
           ],
         ) ,
       ): ListView.builder(
         itemCount: courses_list.length,
           itemBuilder: (context,index){
         final courses = courses_list[index];
         return Card(
           margin:const EdgeInsets.symmetric(horizontal: 16, vertical: 8) ,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
           child: ListTile(
             leading: Text("${index+1}"),
             title: Text(courses.course_title ?? ""),
           ),
         );
       }),
     ),

   );
  }
}