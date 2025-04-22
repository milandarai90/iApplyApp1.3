import 'package:flutter/material.dart';
import 'package:iapply3/models/notification_model.dart';
import 'package:iapply3/services/notification_services.dart';
import 'package:intl/intl.dart';

class notification_activity extends StatefulWidget{
  final String token;
 const notification_activity({required this.token ,super.key});
  @override
  State<StatefulWidget> createState() {
    return notification_activity_state();
  }
}
class notification_activity_state extends State<notification_activity>{
  @override
  void initState() {
    super.initState();
    fetch_notifications();
  }
  bool isLoading = true;
  List<notification_model> notification_list =[];


  Future <void> fetch_notifications() async {
    try {
      final notify_service = notification_services();
      final notify_list = await notify_service.notification(widget.token);
      // print("Fetched ${notify_list.length} notifications");  // Debug line
      if(!mounted)
        return;
      setState(() {
        notification_list = notify_list;
        isLoading = false;
      });
    } catch (e) {
      // print("Error fetching notifications: $e"); // Debug line
      if(!mounted)
        return;
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification",style: TextStyle(color: Theme.of(context).canvasColor),),backgroundColor: Theme.of(context).primaryColor,),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: isLoading ? Center(child: CircularProgressIndicator(),) :
        notification_list.isEmpty ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_very_dissatisfied_rounded,
                    size: 50,
                    color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Notifications are empty", style: TextStyle(color: Colors.grey),),
                  )
                ],
              ),            )
            :
            RefreshIndicator(
              onRefresh: ()async{
                await fetch_notifications();
              },
              child: Container(
                child: ListView.builder(
                  itemCount: notification_list.length,
                    itemBuilder: (context, index){

                   final notify = notification_list[index];

                   String format_datetime = _formatdatetime(notify.created_at);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title:  Text("${notify.notifications ?? ""}",style: TextStyle(color: Theme.of(context).primaryColor),),
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      subtitle: Text("${format_datetime ?? ""}"),
                      trailing: Icon(Icons.more_horiz),
                    ),
                  );
                }),
              ),
            )
      )
    );
  }
}
String _formatdatetime(String? datetime){
  if(datetime == null) return "";
  try{
    DateTime parsedDateTime = DateTime.parse(datetime).toUtc();
    DateTime nepalTime = parsedDateTime.add(Duration(hours: 5 ,minutes: 45));
    return DateFormat('yyyy-MM-dd HH:mm a').format(nepalTime);
  }catch(e){
    return '';
  }
}