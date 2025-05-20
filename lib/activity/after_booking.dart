import 'package:flutter/material.dart';
import 'package:iApply/activity/classes_activity.dart';
import 'package:iApply/models/cancel_booking_model.dart';
import 'package:iApply/services/cancel_booking_services.dart';

class AfterBookingActivity extends StatefulWidget {
  final String consultancy;
  final String token;
  final String branch;
  final String course;
  final String classes;
  final String cid;
  final String bid;
  final String coid;
  final String clid;

  const AfterBookingActivity({
    required this.token,
    required this.course,
    required this.consultancy,
    required this.branch,
    required this.classes,
    required this.bid,
    required this.cid,
    required this.clid,
    required this.coid,
  });

  @override
  State<AfterBookingActivity> createState() => _AfterBookingState();
}

class _AfterBookingState extends State<AfterBookingActivity> {
  late final cancel_booking_request passingCancelData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passingCancelData = cancel_booking_request(
      course_id: widget.coid,
      consultancy_id: widget.cid,
      branch_id: widget.bid,
      classroom_id: widget.clid,
    );
  }

  Future<void> _cancelBooking() async {
    setState(() {
      isLoading = true;
    });
    final cancelService = cancel_booking_services();
    try {
      final cancel_booking_response cancelResponse =
      await cancelService.cancel_booking(passingCancelData, widget.token);
      if (cancelResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text("Booking canceled successfully.")),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => classes_activity(
              consultancy: widget.consultancy,
              branch: widget.branch,
              consultancy_id: widget.cid,
              token: widget.token,
              branch_id: widget.bid,
              course_id: widget.coid,
              course_name: widget.course,
            ),
          ),
              (Route<dynamic> route) => false,
        );
      } else if (cancelResponse.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("Booking cancellation failed.")),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Error occurred during cancellation.")),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: theme.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classes,
            style: TextStyle(color: theme.canvasColor)),
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: theme.canvasColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Consultancy : ${widget.consultancy}", style: textStyle),
              Text("Branch : ${widget.branch}", style: textStyle),
              Text("Course : ${widget.course}", style: textStyle),
              Text("Class : ${widget.classes}", style: textStyle),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: isLoading ? null : _cancelBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: theme.canvasColor,
                      strokeWidth: 2,
                    ),
                  )
                      : Text("Cancel Booking",
                      style: TextStyle(color: theme.canvasColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
