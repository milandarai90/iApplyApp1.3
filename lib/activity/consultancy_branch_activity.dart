import 'package:flutter/material.dart';
import 'package:iapply3/models/consultancy_details_model.dart';
import 'package:iapply3/services/home_data_services.dart';

class consultancy_branch_activity extends StatefulWidget{
  late final String token;
  late final String name;
  late final String id;
  consultancy_branch_activity({super.key,required this.token , required this.id , required this.name});
  @override
  State<StatefulWidget> createState() {
    return consultancy_branch_state();
  }
}
class consultancy_branch_state extends State<consultancy_branch_activity>{
  @override
  void initState() {
    fetch_consultancy_branch();
    super.initState();
  }

  bool isLoading = true;
  List<Branch_details_model> branch_data = [];

  Future <void> fetch_consultancy_branch()async{
    try{
      final service = consultancy_data_services();
      final consultancy_branch_list =await service.consultancy_details(widget.token);

      final matched_consultancy_id = consultancy_branch_list.firstWhere((consultancy) => consultancy.id == widget.id);
      setState(() {
        branch_data = matched_consultancy_id.branch_details;
        isLoading = false;
      });
    }catch(e){
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
        title: Text("Branches, ${widget.name}",style: TextStyle(color: Theme.of(context).canvasColor),),
      iconTheme: IconThemeData(color :Theme.of(context).canvasColor)
    ),
    body: Container(
      margin: const EdgeInsets.only(bottom: 10 ,top: 10),
      child: RefreshIndicator(
        onRefresh: fetch_consultancy_branch,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : branch_data.isEmpty
            ? const Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sentiment_very_dissatisfied_rounded,
                  size: 50,
                  color: Colors.grey,),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No branches found", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ))
            : ListView.builder(
          itemCount: branch_data.length,
          itemBuilder: (context, index) {
            final branch = branch_data[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: branch.photo != null && branch.photo!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    branch.photo!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.business, size: 50, color: Colors.grey),
                title: Text(branch.name ?? ''),
                subtitle: Text(branch.email ?? ''),
                onTap: () {

                },
              ),
            );
          },
        ),
      ),
    ),
  );
  }
}