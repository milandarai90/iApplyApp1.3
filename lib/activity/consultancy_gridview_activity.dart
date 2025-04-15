import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iapply3/models/consultancy_details_model.dart';
import 'package:iapply3/services/home_data_services.dart';

class consultancy_gridview_activity extends StatefulWidget{
   final String token;
  const consultancy_gridview_activity({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return consultancy_gridview_state();
  }
}
class consultancy_gridview_state extends State <consultancy_gridview_activity>{

  bool isLoading = true;
  List<Consultancy_details_model>allconsultancy_list =[];
  void fetch_allconsultancy_data()async{
    try{
      consultancy_data_services allconsultancy_services = consultancy_data_services();
      final response_allconsultancy =await allconsultancy_services.consultancy_details(widget.token);
      allconsultancy_list = response_allconsultancy;
      setState(() {
        isLoading = false;
      });
  }catch(e){
  setState(() {
    isLoading =false;
  });
  }
}
@override
void initState() {
    fetch_allconsultancy_data();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Consultancies",
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
                : allconsultancy_list.isEmpty
                ? Center(
              child: Text(
                "No consultancies available",
                style: TextStyle(color: Colors.red),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(25.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allconsultancy_list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 3/4,
                ),
                itemBuilder: (context, index) {
                  final consultancy = allconsultancy_list[index];
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                           Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              image: consultancy.photo != null
                                  ? DecorationImage(
                                image:
                                NetworkImage(consultancy.photo!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color: Colors.grey[200],
                            ),
                            child: consultancy.photo == null
                                ? Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                                : null,
                          ),

                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(consultancy.name ,style: TextStyle(color: Theme.of(context).primaryColor,),
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
    );
  }


}