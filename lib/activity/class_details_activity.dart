import 'package:flutter/material.dart';

class class_details_acitivty extends StatefulWidget {
  final String token;
  final String consultancy_id;
  final String consultancy;
  final String branch;
  final String course;
  final String branch_id;
  final String course_id;
  final String class_id;
  final String class_name;
  final String students_number;
  final String seat_numbers;
  final String status;
  final String start_time;
  final String end_time;
  final String start_date;
  final String end_date;

  const class_details_acitivty({
    super.key,
    required this.token,
    required this.consultancy_id,
    required this.branch_id,
    required this.course_id,
    required this.class_id,
    required this.class_name,
    required this.students_number,
    required this.seat_numbers,
    required this.status,
    required this.start_time,
    required this.end_time,
    required this.start_date,
    required this.end_date,
    required this.course,
    required this.branch,
    required this.consultancy,
  });

  @override
  State<StatefulWidget> createState() {
    return class_details_state();
  }
}

class class_details_state extends State<class_details_acitivty> {
  int refreshCount = 0;

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      refreshCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
        title: Text(
          "Details for ${widget.class_name}",
          style: TextStyle(color: Theme.of(context).canvasColor),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      color: Theme.of(context).canvasColor,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "${widget.students_number}/${widget.seat_numbers}",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 10,
                                            color: Theme.of(context).primaryColor),
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(200),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${widget.status == 'available' ? 'Available' : 'full'}",
                                      style: TextStyle(fontSize: 16, color: widget.status == 'available' ? Colors.green : Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Class Details",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Class: ${widget.class_name}",style: TextStyle(color: Theme.of(context).primaryColor),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Students: ${widget.students_number}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Capacity: ${widget.seat_numbers}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Status: ${widget.status}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Time: ${widget.start_time} - ${widget.end_time}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Date: ${widget.start_date} / ${widget.end_date}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Other Details",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Consultancy: ${widget.consultancy}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Branch: ${widget.branch}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Course: ${widget.course}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Class: ${widget.class_name}",style: TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "JOIN/BOOK",
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor),
                              ),
                            ),
                          ),
                          // Text("Status: ${widget.status} (Refreshed $refreshCount)"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
