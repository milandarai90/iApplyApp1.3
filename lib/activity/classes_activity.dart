import 'package:flutter/material.dart';
import 'package:iapply3/activity/class_details_activity.dart';
import 'package:iapply3/models/consultancy_details_model.dart';
import 'package:iapply3/services/home_data_services.dart';

class classes_activity extends StatefulWidget{
  final String consultancy_id;
  final String token;
  final String branch_id;
  final String course_id;
  final String course_name;
  final String consultancy;
  final String branch;

  const classes_activity({super.key,required this.consultancy, required this.branch, required this.consultancy_id, required this.token, required this.branch_id, required this.course_id, required this.course_name});

  @override
  State<StatefulWidget> createState() {
    return classes_state();
  }
}
class classes_state extends State<classes_activity>{

  List<Class_details_model>class_list =[];
  bool isLoading = true;

  @override
  void initState() {
  fetch_class_details();
    super.initState();
  }

  Future<void>fetch_class_details()async{
    try{
      consultancy_data_services consultancy_services = consultancy_data_services();
      final response_consultancy =await consultancy_services.consultancy_details(widget.token);
      final matched_consultancy = response_consultancy.firstWhere((consultancy)=> consultancy.id == widget.consultancy_id);
      final response_branch = matched_consultancy.branch_details;
      final matched_branch = response_branch.firstWhere((branch)=> branch.id == widget.branch_id);
      final response_courses = matched_branch.course_details;
      final matched_course = response_courses.firstWhere((course)=> widget.course_id == course.id);
      final response_classes = matched_course.class_details;
      if(!mounted) return;
      setState(() {
         class_list = response_classes;
         isLoading = false;
      });
    }
        catch(e){
          if(!mounted) return;
          setState(() {
        isLoading = false;
      });
        }
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Classes for ${widget.course_name}",style: TextStyle(color: Theme.of(context).canvasColor),),iconTheme: IconThemeData(color: Theme.of(context).canvasColor),backgroundColor: Theme.of(context).primaryColor,),
    body: Container(
      color: Theme.of(context).canvasColor,
      child: isLoading ?
      Center(child: CircularProgressIndicator(),)
          :
          class_list.isEmpty
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_very_dissatisfied_rounded,
              size: 50,
              color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No classes found for ${widget.course_name}", style: TextStyle(color: Colors.grey),),
            )
          ],
        ),
      )
              :
      RefreshIndicator(
        onRefresh: ()async{
         await fetch_class_details();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10 ,top: 10),
          child: ListView.builder(itemCount: class_list.length,
              itemBuilder: (context, index){
            final classes  = class_list[index];
            return Card(
              margin:const EdgeInsets.symmetric(horizontal: 16, vertical: 8) ,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text("${classes.class_name}",style: TextStyle(color: Theme.of(context).primaryColor),),
                leading: CircleAvatar(child: Text("${index + 1}",style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor),),radius: 18,),
                subtitle: Text("${classes.start_time}"),
                trailing: Text("${classes.status == 'available' ? "Available" : "Full" }",style: TextStyle(
                color: (classes.status?.toLowerCase()??'') == 'available'?
                Colors.green :
                Colors.red,
                fontSize: 12),
              ),
                onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> class_details_acitivty(consultancy:widget.consultancy, branch: widget.branch ,course: widget.course_name ,token: widget.token, consultancy_id: widget.consultancy_id, branch_id: widget.branch_id, course_id: widget.course_id, class_id: classes.id!, class_name: classes.class_name!, students_number: classes.students_number!, seat_numbers: classes.seat_numbers!, status: classes.status!, start_time: classes.start_time!, end_time: classes.end_time!, start_date: classes.start_date!, end_date: classes.end_date!,)));
                },
              )
            );
          }),
        ),
      ),
    ),
  );
  }
}