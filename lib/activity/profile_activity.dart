import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iApply/activity/login_activity.dart';
import 'package:iApply/models/avatarChangeModel.dart';
import 'package:iApply/services/avatarChangeServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class profile_activity extends StatefulWidget {

  final String token;

  profile_activity({required this.token});

  @override

  State<StatefulWidget> createState() {
    return profile_activity_state();
  }
}

class profile_activity_state extends State<profile_activity> {
  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  Future<void> imageFromCamera()async{
    final XFile? photo =await picker.pickImage(source: ImageSource.camera);
    if(photo != null){
      setState(() {
        isLoading = true;
      });
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${photo.name}';
      final savedPath = await File(photo.path).copy(newPath);

      final avatarChangeRequest request = avatarChangeRequest(avatar: savedPath);
      final services = avatarChangeServices();
      try{
        final response = await services.changeAvatar(request, widget.token);

        if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text("${response.message}")))
        );
        setState(() {
          isLoading = false;
        });
      }else if(response.statusCode == 300){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.orange,
              content: Center(child: Text("${response.message}")))
      );
      setState(() {
        isLoading = false;
      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text("Unexpected response")),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
    catch(e){

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Center(child: Text("Something went wrong")))
          );
          setState(() {
          isLoading = false;
        });
        print("Upload failed : $e");
          } finally{
        if(!mounted)
          return;
        setState(() {
          isLoading = false;
        });
          }
    }else{
      print("Image Not Clicked");
    }
  }
  Future<void>imageFromGallery()async{
    final XFile? galleryPhoto = await picker.pickImage(source: ImageSource.gallery);
    if(galleryPhoto != null){
      print("Opened");
    }else{
      print("Not opened");
    }
  }

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
      body: Stack(
        children: [
          Container(
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
                        child: GestureDetector(
                          onTap:(){
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: Text("Choose a photo",style: TextStyle(color: Theme.of(context).primaryColor),),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera_alt,size: 30,color: Theme.of(context).primaryColor),
                                          title: Text("Open Camera",style: TextStyle(color: Theme.of(context).primaryColor)),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            imageFromCamera();
                                          }
                                        ),
                                        ListTile(
                                          leading:Icon(Icons.photo,color: Theme.of(context).primaryColor,size: 30,) ,
                                          title: Text("Open Gallery",style: TextStyle(color: Theme.of(context).primaryColor)),
                                          onTap:(){
                                            Navigator.of(context).pop();
                                            imageFromGallery();
                                          }
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } ,

                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor, width: 3),
                            ),
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
          if(isLoading)
          Container(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )

        ]
      ),
    );
  }
}
