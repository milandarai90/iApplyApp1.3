// import 'package:flutter/material.dart';
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../models/login_model.dart';
//
// class myclass_activity extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return myclass_activity_state();
//   }
// }
// class myclass_activity_state extends State<myclass_activity>{
//   @override
//   void initState() {
//     datacheck();
//     super.initState();
//   }
//   List<UserModel>users =[];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
//           backgroundColor: Theme.of(context).primaryColor,
//         title: Text("Testing Users",style: TextStyle(color: Theme.of(context).canvasColor))),
//       body: Container(
//         color: Theme.of(context).canvasColor,
//         child: ListView.builder(
//
//             itemCount : users.length,
//             itemBuilder: (context ,index){
//           final userindex = users[index];
//                  return ListTile(
//             title: Text(userindex.name.fullname),
//               leading:CircleAvatar(child: Text("${index+1}")),
//             subtitle: Text(userindex.email),
//           );
//         }),
//       ),
//     );
//   }
//   void datacheck() async{
//     final uri = 'https://randomuser.me/api/?results=50';
//     final url = Uri.parse(uri);
//     final response = await http.get(url);
//     final body = response.body;
//     final json = jsonDecode(body);
//     final result = json["results"] as List<dynamic>;
//     final dataMapped = result.map((e){
// final name = FullName(
//     title: e['name']['title'],
//     last: e['name']['last'],
//     first: e['name']['first']);
//       return UserModel(
//         email : e['email'],
//         gender : e['gender'],
//         name,
//       );
//     }).toList();
//     setState(() {
//       users = dataMapped;
//     });
//   }
//
// }
//
//
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iapply3/models/myclass_model.dart';
import 'package:iapply3/services/myclass_services.dart';

class myclass_activity extends StatefulWidget{
  final String token;
  myclass_activity({required this.token});

  @override
  State<StatefulWidget> createState() {
    return myclass_state();
  }
}

class myclass_state extends State<myclass_activity>{

  bool isLoading = true;
  List<myclass_model>classes_list = [];

  Future<void>fetch_myclasses()async{
    try{
     final services = myclass_services();
     final myclasses_data = await services.myclass_data(widget.token);
     if(!mounted) return;
     setState(() {
       isLoading = false;
       classes_list = myclasses_data ?? [];
     });
  }
  catch(e){
if(!mounted) return ;
setState(() {
  isLoading= false;
});
  }
  }

  @override
  void initState() {
    fetch_myclasses();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
      child :Scaffold(
      appBar: AppBar(
        bottom:PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical:3 ),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color:  Theme.of(context).primaryColor),
                color: Theme.of(context).canvasColor, // background for the whole tab bar
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(width: 2,color: Colors.white),// background of selected tab
                  borderRadius: BorderRadius.circular(10), // pill shape
                ),
                labelColor: Colors.white, // selected tab text color
                unselectedLabelColor:Theme.of(context).primaryColor,
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
        )
        ,
        title: Text("My Classes" ,
          style: TextStyle(color: Theme.of(context).canvasColor),),
      backgroundColor: Theme.of(context).primaryColor,),
      body: TabBarView(
        children:[
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
            child:ListView.builder(
              itemCount: classes_list.length,
                itemBuilder: (context,index){
                final myClasses = classes_list[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20,top: 15),
                  child: Card(
                    // color: Theme.of(context).canvasColor,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Consultancy: ${myClasses.consultancy}",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                Text("Branch: ${myClasses.branch}",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                Text("Course: ${myClasses.course}",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                Text("Class: ${myClasses.classroom}",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
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
                               Center(child: Icon(Icons.check_circle,color: Colors.green,)),
                               Center(child: Text("Joined",style: TextStyle(color: Colors.green),))
                             ],
                           ),
                         ) else Container(
                             color: Colors.red,
                             child: ElevatedButton(onPressed: (){},
                                 child:Text("Cancel Booking") ),
                           ),
                  ]
                    ),
                  ),
                );
                }) ,
        
          ),
        ),
          ListView(
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
      ]
      ),
    )
    );
  }

}
