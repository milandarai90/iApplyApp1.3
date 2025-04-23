import 'package:flutter/material.dart';
import 'package:iapply3/models/general_country_model.dart';
import 'package:iapply3/services/general_country_services.dart';

import 'country_guidelines_activity.dart';

class all_country_gridview_activity extends StatefulWidget{
  final String token;
  const all_country_gridview_activity({super.key , required this.token});

  @override
  State<StatefulWidget> createState() {
    return all_country_state();
  }

}
class all_country_state extends State<all_country_gridview_activity>{
  bool isLoading = true;
  List<General_country_model>country_data =[];
  @override
  void initState() {
    fetch_allcountry_data();
    super.initState();
  }
  Future<void> fetch_allcountry_data()async{
    try{
      general_country_services country_service = general_country_services();
      final response_allcountry =await country_service.general_country_data(widget.token);
      country_data = response_allcountry;
      if(!mounted) return;
      setState(() {
        isLoading = false;
      });
    }catch(e){
      if(!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
       backgroundColor: Theme.of(context).primaryColor,
       title: Text(
         "Countries",
         style: TextStyle(color: Theme.of(context).canvasColor),
       ),
     ),
     body: InkWell(
       onTap: () {
         FocusScope.of(context).unfocus();
       },
       child: Container(
         height: MediaQuery.of(context).size.height,
         color: Theme.of(context).canvasColor,
         child: SafeArea(
           child: isLoading
               ? Center(child: CircularProgressIndicator())
               : country_data.isEmpty
               ?RefreshIndicator(
             onRefresh: fetch_allcountry_data,
             child: ListView(
               physics: const AlwaysScrollableScrollPhysics(),
               children: [
                 SizedBox(
                   height: MediaQuery.of(context).size.height * 0.7,
                   child: Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children:  [
                         Icon(Icons.sentiment_very_dissatisfied_rounded, size: 50, color: Colors.grey),
                         Padding(
                           padding: EdgeInsets.all(8.0),
                           child: Text("No countries found", style:TextStyle(color: Colors.grey)),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           )
               : Padding(
             padding: const EdgeInsets.all(25.0),
             child: RefreshIndicator(
               onRefresh: fetch_allcountry_data,
               child: GridView.builder(
                 shrinkWrap: true,
                 physics: AlwaysScrollableScrollPhysics(),
                 itemCount: country_data.length,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3,
                   mainAxisSpacing: 10,
                   crossAxisSpacing: 20,
                   childAspectRatio: 3/4,
                 ),
                 itemBuilder: (context, index) {
                   final country_list = country_data[index];
                   return Container(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => general_country_activity(token : widget.token , id : country_list.id , country : country_list.country!)));
                           },
                           child: Container(
                             width: 90,
                             height: 90,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               border: Border.all(
                                 color: Theme.of(context).primaryColor,
                               ),
                               image: country_list.map != null
                                   ? DecorationImage(
                                 image:
                                 NetworkImage(country_list.map!),
                                 fit: BoxFit.cover,
                               )
                                   : null,
                               color: Colors.grey[200],
                             ),
                             child: country_list.map == null
                                 ? Center(
                               child: Icon(
                                 Icons.image_not_supported,
                                 size: 40,
                                 color: Colors.grey,
                               ),
                             )
                                 : null,
                           ),
                         ),

                         const SizedBox(height: 15),
                         Padding(
                           padding: const EdgeInsets.only(left: 5.0),
                           child: SizedBox(
                             child: Align(
                               alignment: Alignment.center,
                               child: Text(country_list.country.toString() ,style: TextStyle(color: Theme.of(context).primaryColor,),
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   );
                 },
               ),
             ),
           ),
         ),
       ),
     ),
   );
  }

}