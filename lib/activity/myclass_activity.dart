import 'package:flutter/material.dart';
import 'package:iApply/models/cancel_booking_model.dart';
import 'package:iApply/models/myclass_model.dart';
import 'package:iApply/models/requestedClass_model.dart';
import 'package:iApply/services/cancel_booking_services.dart';
import 'package:iApply/services/myclass_services.dart';
import 'package:iApply/services/requestedClassService.dart';

class myclass_activity extends StatefulWidget {
  final String token;
  myclass_activity({required this.token});

  @override
  State<StatefulWidget> createState() {
    return myclass_state();
  }
}

class myclass_state extends State<myclass_activity> {
  bool isLoading = true;
  List<myclass_model> classes_list = [];


  Future<void> fetch_myclasses() async {
    try {
      final services = myclass_services();
      final myclasses_data = await services.myclass_data(widget.token);
      if (!mounted) return;
      setState(() {
        isLoading = false;
        classes_list = myclasses_data ?? [];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  List<requestedClassModel> requestedClassesList = [];

  Future<void> fetch_requestedClasses() async {
    try {
      final requestClass = requestedClassServices();
      final requested_data = await requestClass.requestedClasses(widget.token);
      if (!mounted) return;
      setState(() {
        isLoading = false;
        requestedClassesList = requested_data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
    }
  }

  late cancel_booking_request passCancelBookingData;

  @override
  void initState() {
    fetch_myclasses();
    fetch_requestedClasses();
    passCancelBookingData = cancel_booking_request(course_id: "", consultancy_id: "", branch_id: "", classroom_id: "");
    super.initState();
  }


  void _cancelBooking()async{
    setState(() {
      isLoading = true;
    });
    try{
      final service = cancel_booking_services();
      final cancel_booking_response response =await service.cancel_booking(passCancelBookingData, widget.token);
      print(response.message);
      if(response.statusCode == 200){
        setState(() {
          fetch_requestedClasses();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text("Booking canceled successfully.")),
          ),
        );
      }else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("Booking cancellation failed.")),
          ),
        );
      }
    }
        catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text("Something went wrong.")),
            ),
          );
        }
    finally{
      if(!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  color: Theme.of(context).canvasColor, // background for the whole tab bar
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(width: 2, color: Colors.white), // background of selected tab
                    borderRadius: BorderRadius.circular(10), // pill shape
                  ),
                  labelColor: Colors.white, // selected tab text color
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  isScrollable: false,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab, // full width of tab
                  tabs: [
                    Tab(text: 'Joined'),
                    Tab(text: 'Requested'),
                  ],
                ),
              ),
            ),
          ),
          title: Text(
            "My Classes",
            style: TextStyle(color: Theme.of(context).canvasColor),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: TabBarView(
          children: [
            // First tab: Joined Classes (unchanged)
            Container(
              color: Theme.of(context).canvasColor,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : classes_list.isEmpty
                  ? RefreshIndicator(
                onRefresh: fetch_myclasses,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.sentiment_very_dissatisfied_rounded, size: 50, color: Colors.grey),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("You haven't joined any classes yet.", style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: fetch_myclasses,
                child: ListView.builder(
                  itemCount: classes_list.length,
                  itemBuilder: (context, index) {
                    final myClasses = classes_list[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Consultancy: ${myClasses.consultancy}",
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Text("Branch: ${myClasses.branch}",
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Text("Course: ${myClasses.course}",
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Text("Class: ${myClasses.classroom}",
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                            if (myClasses.status == "joined")
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(child: Icon(Icons.check_circle, color: Colors.green)),
                                    Center(child: Text("Joined", style: TextStyle(color: Colors.green)))
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Second tab: Requested Classes (Updated)
            isLoading
                ? Container(
              color: Theme.of(context).canvasColor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : requestedClassesList.isNotEmpty
                ? RefreshIndicator(
              onRefresh: fetch_requestedClasses,
              child: ListView.builder(
                itemCount: requestedClassesList.length,
                itemBuilder: (context, index) {
                  final requestedClasses = requestedClassesList[index];
                  String consultancyName = requestedClasses.consultancy?.consultancy_details?.name ?? "No Name";
                  String branchName = requestedClasses.branch?.branch_details?.name ?? "No Branch";
                  String courseName = requestedClasses.course?.course ?? "No Course";
                  String className = requestedClasses.classroom?.class_name ?? "No Class";

                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Consultancy: $consultancyName",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  Text("Branch: $branchName",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  Text("Course: $courseName",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  Text("Class: $className",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                          if (requestedClasses.status == "book")
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    passCancelBookingData = cancel_booking_request(course_id:requestedClasses.course_id , consultancy_id: requestedClasses.consultancy_id, branch_id: requestedClasses.branch_id, classroom_id: requestedClasses.classroom_id);
                                  });
                                  _cancelBooking();
                                },

                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cancel, color: Colors.red),
                                    Text("Cancel", style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
                : RefreshIndicator(
              onRefresh: fetch_requestedClasses,
                  child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.sentiment_very_dissatisfied_rounded, size: 50, color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("You haven't requested any classes yet.", style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                                ],
                              ),
                ),
          ],
        ),
      ),
    );
  }
}
