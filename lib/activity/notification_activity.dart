import 'package:flutter/material.dart';
import 'package:iApply/models/notification_model.dart';
import 'package:iApply/services/notification_services.dart';
import 'package:intl/intl.dart';
class notification_activity extends StatefulWidget {
  final String token;
  const notification_activity({required this.token, super.key});

  @override
  State<notification_activity> createState() => notification_activity_state();
}

class notification_activity_state extends State<notification_activity> {
  bool isLoading = true;
  List<notification_model> notificationList = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final notifyService = notification_services();
      final notifyList = await notifyService.notification(widget.token);
      if (!mounted) return;
      setState(() {
        notificationList = notifyList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  String _formatDatetime(String? datetime) {
    if (datetime == null) return "";
    try {
      final parsedDateTime = DateTime.parse(datetime).toUtc();
      final nepalTime = parsedDateTime.add(const Duration(hours: 5, minutes: 45));
      return DateFormat('yyyy-MM-dd HH:mm a').format(nepalTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification", style: TextStyle(color: Theme.of(context).canvasColor)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notificationList.isEmpty
            ? RefreshIndicator(
          onRefresh: fetchNotifications,
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
          child: Text("Notifications are empty", style: TextStyle(color: Colors.grey)),
          ),
          ],
          ),
          ),
          ),
          ],
          ),
    )


            : RefreshIndicator(
          onRefresh: fetchNotifications,
          child: ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              final notify = notificationList[index];
              final formattedDate = _formatDatetime(notify.created_at);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                      notify.notifications ?? "",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    leading: const CircleAvatar(
                        radius :25,child: Icon(Icons.person,size: 30,)),
                    subtitle: Text(formattedDate),
                    trailing: const Icon(Icons.more_horiz),
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
