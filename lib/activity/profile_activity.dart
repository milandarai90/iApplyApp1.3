import 'package:flutter/material.dart';
import 'package:iApply/activity/login_activity.dart';

class profile_activity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return profile_activity_state();
  }
}

class profile_activity_state extends State<profile_activity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Theme.of(context).canvasColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 3),
                        ),
                        child: GestureDetector(
                          onTap:(){
                           showDialog(
                               context: context,
                               barrierDismissible: true,
                               builder: (BuildContext context){
                                 return AlertDialog(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                   title: Text("Choose a photo"),
                                   content: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       ListTile(
                                         leading: Icon(Icons.camera_alt),
                                         title: Text("Open Camera"),
                                         onTap: (){

                                         },
                                       ),
                                       ListTile(
                                         leading:Icon(Icons.photo) ,
                                         title: Text("Open Gallery"),
                                         onTap: (){

                                         },
                                       )
                                     ],
                                   ),
                                 );
                               });
                          } ,
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                                  "My Details",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      // ✅ Added Logout Gesture
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => login_activity()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
