

import 'package:flutter/material.dart';
import 'package:iapply3/activity/all_country_gridview_activity.dart';
import 'package:iapply3/activity/consultancy_branch_activity.dart';
import 'package:iapply3/activity/consultancy_gridview_activity.dart';
import 'package:iapply3/activity/country_guidelines_activity.dart';
import 'package:iapply3/models/consultancy_details_model.dart';
import 'package:iapply3/models/general_country_model.dart';
import 'package:iapply3/services/general_country_services.dart';
import 'package:iapply3/services/home_data_services.dart';

class home_activity extends StatefulWidget{
  final String token;
  const home_activity({super.key, required this.token});
  @override
  State<StatefulWidget> createState() {
    return home_activity_state();
  }
}
class home_activity_state extends State<home_activity>{

  List<Consultancy_details_model>consultancy_details_list =[];
  List<General_country_model>general_country_list =[];
  int myIndex =0;
  bool isLoading =true;
  

  @override
  void initState() {
    super.initState();
    fetch_general_country();
    fetch_consultancy_details();
  }

  Future <void> fetch_consultancy_details() async {
    try {
      consultancy_data_services service = consultancy_data_services();
      final response = await service.consultancy_details(widget.token);
      consultancy_details_list = response;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future <void> fetch_general_country()async{
    try{
      general_country_services country_service = general_country_services();
      final response_country = await country_service.general_country_data(widget.token);
      general_country_list = response_country;
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading= false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: (){
         FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: ()async{
                setState(() {
                  isLoading = true;
                });
                await fetch_general_country();
                await fetch_consultancy_details();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0,bottom: 30 ,left: 25,right: 28 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),),
                              Text('@username',style: TextStyle(color: Colors.white,fontSize:28 ,fontWeight: FontWeight.w500),)
                            ],
                          ),
                          SizedBox(
                              height: 45,
                              width: 116,
                              child: Image.asset('assets/images/iapply_logo.png'))
                        ],
                      ),
                    ),
                    Container(
                      color: hexToColor("7E6BA3"),
                      child: Padding(
                        padding: const EdgeInsets.only(left:25,right: 25,bottom: 10,top: 10 ),
                        child: SizedBox(
                          child: TextFormField(
                            autofocus: false,
                            decoration: InputDecoration(
                              // contentPadding: EdgeInsets.symmetric(vertical: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 3
                                  ),
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(27),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor,
                                        width: 1
                                    )
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 16,),
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(onPressed: (){
                                }, icon: Icon(Icons.search,color: Theme.of(context).primaryColor,)
                                ),
                                // iconColor: Theme.of(context).canvasColor

                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(height: 25,
                          color: Theme.of(context).canvasColor,),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Top Consultancies',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18,fontWeight: FontWeight.w500),),
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => consultancy_gridview_activity(token: widget.token)));
                                }, child: Text('More',style:TextStyle(color: hexToColor('40D900')) ,))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 18),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:isLoading? SizedBox(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : consultancy_details_list.isEmpty
                                  ? SizedBox(
                                height: 90,
                                    width: 90,
                                    child: Center(
                                      child: Center(
                                    child: Text(
                                      "No consultancies found",
                                      style: TextStyle(color: Colors.red),
                                    ),),
                                    ),
                                  )
                                  :
                              Row(
                                children: consultancy_details_list.take(5).map((consultancy){
                                  return  Padding(
                                    padding: const EdgeInsets.only(right: 8,top: 10, bottom: 10,left: 28),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> consultancy_branch_activity(token:widget.token,id :consultancy.id , name : consultancy.name)));
                                      },
                                      child: SizedBox(
                                        width: 90,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 90,
                                              // width: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 1
                                                ),
                                                image: consultancy.photo != null ?
                                                DecorationImage(
                                                    image: NetworkImage(consultancy.photo!),
                                                      fit: BoxFit.cover,
                                                ) : null,
                                                  borderRadius: BorderRadius.circular(16),
                                                  color: Colors.blueAccent
                                              ),
                                              child: consultancy.photo == null
                                                  ? const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            const SizedBox(height: 15),
                                            SizedBox(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(consultancy.name ,style: TextStyle(color: Theme.of(context).primaryColor,),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()

                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).canvasColor,),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Countries',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18,fontWeight: FontWeight.w500),),
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => all_country_gridview_activity(token : widget.token)));
                                }, child: Text('More',style:TextStyle(color: hexToColor('40D900')) ,))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 18),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: isLoading? SizedBox(
                                  height:140,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(child: CircularProgressIndicator(),))
                              :general_country_list.isEmpty?
                              Center(
                                child: SizedBox(
                                  height: 90,
                                  // width: 90,
                                  child: Center(
                                    child: Text("No country found" , style: TextStyle(color: Colors.red),),
                                  ),
                                ),
                              ):
                              Row(
                                children: general_country_list.reversed.take(5).toList().reversed.map((country){
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8,top: 10, bottom: 10,left: 28),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => general_country_activity(token : widget.token , id : country.id , country : country.country!)));
                                      },
                                      child: SizedBox(
                                        width: 90,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context).primaryColor,
                                                  width: 1
                                                ),
                                                  borderRadius: BorderRadius.circular(16),
                                                  color: Colors.blueAccent,
                                                image: country.map !=null ?
                                                    DecorationImage(image: NetworkImage(country.map!),
                                                      fit: BoxFit.cover
                                                    ):null,
                                              ),
                                              child: country.map == null ? Center(
                                                child: Icon(Icons.image_not_supported,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                              ):null,
                                            ),
                                            const SizedBox(height: 15),
                                            SizedBox(
                                              // height:20,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(country.country!,
                                                  style: TextStyle(color: Theme.of(context).primaryColor,),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 80,
                      child: Container(

                        color: Theme.of(context).canvasColor,
                      ),
                    )
                  ],
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }
}
Color hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // Add alpha value if not provided
  }
  return Color(int.parse("0x$hexColor"));
}