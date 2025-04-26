import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iapply3/models/consultancy_details_model.dart';
import 'package:iapply3/services/home_data_services.dart';
import 'consultancy_branch_activity.dart';

class consultancy_gridview_activity extends StatefulWidget {
  final String token;
  const consultancy_gridview_activity({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return consultancy_gridview_state();
  }
}

class consultancy_gridview_state extends State<consultancy_gridview_activity> {
  bool isLoading = true;
  List<Consultancy_details_model> allconsultancy_list = [];

  Future<void> fetch_allconsultancy_data() async {
    try {
      consultancy_data_services allconsultancy_services = consultancy_data_services();
      final response_allconsultancy = await allconsultancy_services.consultancy_details(widget.token);
      allconsultancy_list = response_allconsultancy;
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetch_allconsultancy_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).canvasColor),
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
                ? const Center(child: CircularProgressIndicator())
                : allconsultancy_list.isEmpty
                ? RefreshIndicator(
              onRefresh: fetch_allconsultancy_data,
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
                            child: Text(
                              "No Consultancies found",
                              style: TextStyle(color: Colors.grey),
                            ),
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
                onRefresh: fetch_allconsultancy_data,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: allconsultancy_list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final consultancy = allconsultancy_list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => consultancy_branch_activity(
                              token: widget.token,
                              id: consultancy.id,
                              name: consultancy.name,
                            ),
                          ),
                        );
                      },
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
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: consultancy.photo != null && consultancy.photo!.isNotEmpty
                                  ? Image.network(
                                consultancy.photo!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                                  : const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: SizedBox(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  consultancy.name,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
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
