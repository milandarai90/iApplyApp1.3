import 'package:flutter/material.dart';

class after_booking_activity extends StatefulWidget{
  @override
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
                  child: ElevatedButton(onPressed: (){}, child: Text("Cancel Booking",style: TextStyle(color: Theme.of(context).canvasColor),),
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