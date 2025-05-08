import 'package:flutter/material.dart';
import 'package:iApply/activity/courses_activity.dart';
import 'package:iApply/models/consultancy_details_model.dart';
import 'package:iApply/services/home_data_services.dart';

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
      if(!mounted) return;
      setState(() {
        branch_data = matched_consultancy_id.branch_details;
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
      backgroundColor:Theme.of(context).primaryColor ,
        title: Text("Branches, ${widget.name}",style: TextStyle(color: Theme.of(context).canvasColor),),
      iconTheme: IconThemeData(color :Theme.of(context).canvasColor)
    ),
    body: Container(
      color: Theme.of(context).canvasColor,
      margin: const EdgeInsets.only(bottom: 10 ,top: 10),
      child: RefreshIndicator(
        onRefresh: fetch_consultancy_branch,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : branch_data.isEmpty
            ? RefreshIndicator(
          onRefresh: fetch_consultancy_branch,
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
                        child: Text("No branches found for ${widget.name}", style:TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: branch_data.length,
          itemBuilder: (context, index) {
            final branch = branch_data[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                // trailing: Icon(Icons.arrow_forward),
                leading: branch.photo != null && branch.photo!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    branch.photo!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context,error, stackTrace){
                      return const Icon(Icons.business,size: 40,color: Colors.grey,);
                    },
                  ),
                )
                    : const Icon(Icons.business, size: 50, color: Colors.grey),
                title: Text(branch.name ?? ''),
                subtitle: Text(branch.email ?? ''),
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>courses_activity(consultancy: widget.name,token:widget.token ,branch:branch.name!,consultancy_id:widget.id!, branch_id : branch.id!)));
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