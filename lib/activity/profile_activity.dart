import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iApply/activity/login_activity.dart';
import 'package:iApply/models/avatarChangeModel.dart';
import 'package:iApply/models/userDetailsModel.dart';
import 'package:iApply/services/avatarChangeServices.dart';
import 'package:iApply/services/userDetailsServices.dart';
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
  userDataModel? userdata;

  @override
  void initState() {
    fetchUserDetails();
    super.initState();
  }

  Future<void> imageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        isLoading = true;
      });
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${photo.name}';
      final savedPath = await File(photo.path).copy(newPath);

      final avatarChangeRequest request = avatarChangeRequest(avatar: savedPath);
      final services = avatarChangeServices();

      try {
        final response = await services.changeAvatar(request, widget.token);
        showSnackbar(response.message, response.statusCode);
        setState(() {
          fetchUserDetails();
        });
      } catch (e) {
        showSnackbar("Something went wrong", 500);
      } finally {
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> imageFromGallery() async {
    final XFile? galleryImage = await picker.pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      setState(() {
        isLoading = true;
      });
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${galleryImage.name}';
      final savedPath = await File(galleryImage.path).copy(newPath);

      final request = avatarChangeRequest(avatar: savedPath);
      final services = avatarChangeServices();

      try {
        final response = await services.changeAvatar(request, widget.token);
        showSnackbar(response.message, response.statusCode);
        setState(() {
          fetchUserDetails();

        });
      } catch (e) {
        showSnackbar("Something went wrong", 500);
      } finally {
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    }
  }

  void fetchUserDetails() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      userDetailsServices service = userDetailsServices();
      final response = await service.userDetails(widget.token);
      setState(() {
        userdata = response.data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message, int statusCode) {
    Color color;
    if (statusCode == 200) {
      color = Colors.green;
    } else if (statusCode == 300) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Center(child: Text(message)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? profilePath = userdata?.profileImage?.image_path != null &&
        userdata!.profileImage!.image_path!.isNotEmpty
        ? "https://iapply.techenfield.com/storage/${userdata!.profileImage!.image_path}"
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh : ()async{
       fetchUserDetails();
    },
            child: Container(
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                         child:  Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: profilePath != null
                                  ? CachedNetworkImage(
                                imageUrl: profilePath,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Theme.of(context).primaryColor,
                                  size: 50,
                                ),
                              )
                                  : Icon(
                                Icons.add_photo_alternate,
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                            ),
                          ),

                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text("Choose a photo",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt,
                                            size: 30,
                                            color:
                                            Theme.of(context).primaryColor),
                                        title: Text("Open Camera",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          imageFromCamera();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo,
                                            color:
                                            Theme.of(context).primaryColor,
                                            size: 30),
                                        title: Text("Open Gallery",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          imageFromGallery();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              "Change",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "${userdata?.name ?? ""}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 1,
                        endIndent: 30,
                        indent: 30,
                        color: Theme.of(context).primaryColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 230,
                                        child: Column(
                                        children: [
                                            Center(
                                              child: Text("My Details",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context).primaryColor,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                            Divider(thickness: 2),
                                          SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Name: ",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600)),
                                                Expanded(child: Text(userdata?.name ?? "")),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Email: ",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600)),
                                                Expanded(child: Text(userdata?.email ?? "")),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            (userdata?.phone?.isNotEmpty == true)?
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Phone: ",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600)),
                                                Expanded(child: Text(userdata?.phone ?? "")),
                                              ],
                                            ) : Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Phone:",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600
                                                    )),
                                                Expanded(child: Text(" N/A"))
                                              ],
                                            )
                                            ,

                                            SizedBox(height: 6),
                                            (userdata?.u_ward?.isNotEmpty == true &&
                                                userdata?.u_municipality?.isNotEmpty ==
                                                    true &&
                                                userdata?.u_district?.isNotEmpty == true)?
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Address: ",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600)),
                                                Expanded(
                                                  child: Text(
                                                      "${userdata?.u_municipality} - ${userdata?.u_ward}, ${userdata?.u_district}"),
                                                ),
                                              ],
                                            ) :Row(
                                                children: [
                                                  Text("Address: ", style: TextStyle(
                                                      fontWeight: FontWeight.w600)),
                                                  Expanded(child: Text("N/A"),
                                                  ),
                                                ]
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Change Password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
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
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("Logout",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}