import 'package:flutter/material.dart';
import 'package:iapply3/activity/class_details_activity.dart';
import 'package:iapply3/activity/classes_activity.dart';
import 'package:iapply3/models/cancel_booking_model.dart';
import 'package:iapply3/services/cancel_booking_services.dart';

class after_booking_activity extends StatefulWidget{
  final String consultancy;
  final String token;
  final String branch;
  final String course;
  final String classes;
  final String cid;
  final String bid;
  final String coid;
  final String clid;

const after_booking_activity({required this.token, required this.course, required this.consultancy, required this.branch, required this.classes, required this.bid, required this.cid , required this.clid , required this.coid});


  State<StatefulWidget> createState() {
    return after_booking_state();
  }

}
class after_booking_state extends State<after_booking_activity>{
  late final cancel_booking_request passing_cancel_data;
  bool isCanceled = false;

  @override
  void initState() {
    passing_cancel_data = cancel_booking_request(course_id: widget.coid, consultancy_id: widget.cid, branch_id: widget.bid, classroom_id: widget.clid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.classes}",style:TextStyle(color: Theme.of(context).canvasColor)),backgroundColor: Theme.of(context).primaryColor,iconTheme: IconThemeData(color: Theme.of(context).canvasColor),),
      body: SizedBox(
        // height: 180,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Consultancy : ${widget.consultancy}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16 ,fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Branch : ${widget.branch}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16 ,fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Course : ${widget.course}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16 ,fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Class : ${widget.classes}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16 ,fontWeight: FontWeight.w500),),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: ()async{
                    cancel_booking_services cancel = cancel_booking_services();
                    try{
                      cancel_booking_response cancel_response =await cancel.cancel_booking(passing_cancel_data, widget.token);
                      if(cancel_response.statusCode == 200 ){
                        setState(() {
                          isCanceled = true;
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => classes_activity(consultancy: widget.consultancy, branch: widget.branch, consultancy_id: widget.cid, token: widget.token, branch_id: widget.bid, course_id: widget.coid, course_name: widget.course)),
                              (Route<dynamic> route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                              content: Center(
                            child: Text("Booking canceled successfully."),))
                        );
                      }else if(cancel_response.statusCode == 400){
                        setState(() {
                          isCanceled =false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.green,
                                content: Center(
                                  child: Text("Booking cancellation failed."),))
                        );
                      }
                    }
                        catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                            content:Center(child: Text("Error occurred during cancellation."),) )
                      );
                        }

                  },
                    child: Text("Cancel Booking",style: TextStyle(color: Theme.of(context).canvasColor),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                  ),),
                )

              ],
            ),
          ),
        ),
      )
    );
  }

}