import 'package:flutter/material.dart';
import 'package:iapply3/models/general_country_model.dart';
import 'package:iapply3/services/general_country_services.dart';

class general_country_activity extends StatefulWidget{
  final String token;
  final String id;
final String country;
  const general_country_activity({required this.id, required this.token, required this.country});
  @override
  State<StatefulWidget> createState() {
   return general_country_state();
  }
}
class general_country_state extends State<general_country_activity>{

  List<Guidelines_model> guidelines_list = [];
  bool isLoading = true;

  @override
  void initState() {
fetch_country_guidelines();
super.initState();
  }

  Future <void> fetch_country_guidelines()async{
    try{
      final guidelines_services = general_country_services();
      final country_guidelines_list =await guidelines_services.general_country_data(widget.token);
      final matched_country = country_guidelines_list.firstWhere((country) => country.id == widget.id);

      setState(() {
        guidelines_list = matched_country.guidelines_data;
        isLoading = false;
      });
    }
        catch(e){
      setState(() {
        isLoading = false;
      });
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:Theme.of(context).primaryColor ,
          title: Text("Guidelines for ${widget.country} ",style: TextStyle(color: Theme.of(context).canvasColor),),
          iconTheme: IconThemeData(color :Theme.of(context).canvasColor)
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 10 ,top: 10),
        child: RefreshIndicator(
          onRefresh: ()async{
           await fetch_country_guidelines;
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : guidelines_list.isEmpty
              ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_very_dissatisfied_rounded,
                  size: 50,
                  color: Colors.grey,),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("No Guidelines found", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ))
              : ListView.builder(
            itemCount: guidelines_list.length,
            itemBuilder: (context, index) {
              final guidelines = guidelines_list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                 leading: CircleAvatar(
                   radius: 18,
                     child: Text("${index +1}",style: TextStyle(fontSize: 14),)),
                  title: Text(guidelines.Guidelines ?? ''),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}