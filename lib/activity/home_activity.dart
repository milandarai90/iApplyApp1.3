import 'package:flutter/material.dart';
import 'package:iApply/activity/all_country_gridview_activity.dart';
import 'package:iApply/activity/consultancy_branch_activity.dart';
import 'package:iApply/activity/consultancy_gridview_activity.dart';
import 'package:iApply/activity/country_guidelines_activity.dart';
import 'package:iApply/models/consultancy_details_model.dart';
import 'package:iApply/models/general_country_model.dart';
import 'package:iApply/models/userDetailsModel.dart';
import 'package:iApply/services/general_country_services.dart';
import 'package:iApply/services/home_data_services.dart';
import 'package:iApply/services/userDetailsServices.dart';

class home_activity extends StatefulWidget {
  final String token;
  const home_activity({super.key, required this.token});
  @override
  State<StatefulWidget> createState() {
    return home_activity_state();
  }
}

class home_activity_state extends State<home_activity> {
  List<Consultancy_details_model> consultancy_details_list = [];
  List<General_country_model> general_country_list = [];
  bool isLoading = true;

  List<_SearchResultItem> searchResults = [];
  TextEditingController searchController = TextEditingController();

  userDataModel? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchAllData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAllData() async {
    try {
      general_country_services country_service = general_country_services();
      consultancy_data_services consultancy_service = consultancy_data_services();

      final results = await Future.wait([
        country_service.general_country_data(widget.token),
        consultancy_service.consultancy_details(widget.token)
      ]);

      general_country_list = results[0] as List<General_country_model>;
      consultancy_details_list = results[1] as List<Consultancy_details_model>;

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

  Future<void> fetchUserName() async {
    setState(() {
      isLoading = true;
    });
    try {
      userDetailsServices userServices = userDetailsServices();
      final userData = await userServices.userDetails(widget.token);
      if (!mounted) return;
      setState(() {
        userName = userData.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchData(String query) {
    List<_SearchResultItem> results = [];

    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final q = query.toLowerCase();

    for (var consultancy in consultancy_details_list) {
      // Check consultancy name
      if (consultancy.name.toLowerCase().contains(q)) {
        results.add(_SearchResultItem(
          type: _SearchResultType.Consultancy,
          consultancy: consultancy,
        ));
      }

      // Check branches
      for (var branch in consultancy.branch_details) {
        if (branch.name != null && branch.name!.toLowerCase().contains(q)) {
          results.add(_SearchResultItem(
            type: _SearchResultType.Branch,
            consultancy: consultancy,
            branch: branch,
          ));
        }

        // Check courses
        for (var course in branch.course_details) {
          if (course.course_title != null &&
              course.course_title!.toLowerCase().contains(q)) {
            results.add(_SearchResultItem(
              type: _SearchResultType.Course,
              consultancy: consultancy,
              branch: branch,
              course: course,
            ));
          }
        }
      }
    }

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            searchResults = [];
            searchController.clear();
          });
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                if (!mounted) return;
                setState(() {
                  isLoading = true;
                });
                await fetchAllData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30, left: 25, right: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '${userName?.name ?? "username"}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(
                              height: 50,
                              width: 116,
                              child: Image.asset('assets/images/iapply_logo.png'))
                        ],
                      ),
                    ),
                    Container(
                      color: hexToColor("7E6BA3"),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 10, top: 10),
                        child: SizedBox(
                          child: TextFormField(
                            controller: searchController,
                            autofocus: false,
                            onChanged: (value) {
                              searchData(value);
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(27),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(27),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1)),
                              hintText: "Search",
                              hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  searchData(searchController.text);
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (searchResults.isNotEmpty)
                      Container(
                        color: Colors.white,
                        constraints: BoxConstraints(
                          maxHeight: 300,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];
                            String title = '';
                            String subtitle = '';
                            IconData icon;

                            switch (item.type) {
                              case _SearchResultType.Consultancy:
                                title = item.consultancy!.name;
                                subtitle = "Consultancy";
                                icon = Icons.business;
                                break;
                              case _SearchResultType.Branch:
                                title = item.branch!.name ?? "";
                                subtitle = "Branch of ${item.consultancy!.name}";
                                icon = Icons.account_tree;
                                break;
                              case _SearchResultType.Course:
                                title = item.course!.course_title ?? "";
                                subtitle =
                                "Course in ${item.branch!.name} branch";
                                icon = Icons.book;
                                break;
                            }

                            return ListTile(
                              leading: Icon(icon, color: Theme.of(context).primaryColor),
                              title: Text(title),
                              subtitle: Text(subtitle),
                              onTap: () {
                                if (item.type == _SearchResultType.Consultancy) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => consultancy_branch_activity(
                                          token: widget.token,
                                          id: item.consultancy!.id,
                                          name: item.consultancy!.name),
                                    ),
                                  );
                                } else if (item.type == _SearchResultType.Branch) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => consultancy_branch_activity(
                                          token: widget.token,
                                          id: item.consultancy!.id,
                                          name: item.branch!.name ?? ""),
                                    ),
                                  );
                                } else if (item.type == _SearchResultType.Course) {
                                  // Navigate to course details page, replace with your actual screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CourseDetailsScreen(
                                        token: widget.token,
                                        consultancyId: item.consultancy!.id,
                                        branchId: item.branch!.id ?? "",
                                        courseId: item.course!.id ?? "",
                                        courseTitle: item.course!.course_title ?? "",
                                      ),
                                    ),
                                  );
                                }
                                // Clear search after navigating
                                setState(() {
                                  searchResults = [];
                                  searchController.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),

                    // Original UI below remains unchanged
                    Column(
                      children: [
                        Container(
                          height: 25,
                          color: Theme.of(context).canvasColor,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Consultancies',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  consultancy_gridview_activity(
                                                      token: widget.token)));
                                    },
                                    child: Text(
                                      'More',
                                      style: TextStyle(
                                          color: hexToColor('40D900')),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          width: double.infinity,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 20, bottom: 18),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: isLoading
                                  ? SizedBox(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : consultancy_details_list.isEmpty
                                  ? SizedBox(
                                height: 90,
                                width:
                                MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Center(
                                    child: Text(
                                      "No consultancies found",
                                      style:
                                      TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )
                                  : Row(
                                children: consultancy_details_list
                                    .take(5)
                                    .map((consultancy) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8,
                                        top: 10,
                                        bottom: 10,
                                        left: 28),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    consultancy_branch_activity(
                                                        token:
                                                        widget.token,
                                                        id:
                                                        consultancy
                                                            .id,
                                                        name: consultancy
                                                            .name)));
                                      },
                                      child: SizedBox(
                                        width: 90,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                              consultancy.photo ==
                                                  null
                                                  ? AssetImage(
                                                  "assets/images/dummy_profile.jpg")
                                                  : NetworkImage(
                                                  consultancy.photo!)
                                              as ImageProvider,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 12.0),
                                              child: Text(
                                                consultancy.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400),
                                                maxLines: 2,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 20, right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            all_country_gridview_activity(
                                                token: widget.token)));
                              },
                              child: const Text('Explore Countries'),
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 25, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Country Guidelines',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  all_country_gridview_activity(
                                                      token: widget.token)));
                                    },
                                    child: Text(
                                      'More',
                                      style: TextStyle(
                                          color: hexToColor('40D900')),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 25, right: 25, top: 20, bottom: 25),
                            child: isLoading
                                ? Center(
                              child: CircularProgressIndicator(),
                            )
                                : general_country_list.isEmpty
                                ? Center(
                              child: Text(
                                "No guidelines found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                                : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: general_country_list.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    general_country_activity(
                                                        token:
                                                        widget.token,
                                                        id: general_country_list[
                                                        index]
                                                            .id,
                                                        country:
                                                        general_country_list[
                                                        index]
                                                            .country!)));
                                      },
                                      child: SizedBox(
                                        height: 36,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(6)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                general_country_list[index]
                                                    .map ??
                                                    "",
                                                height: 36,
                                                width: 54,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                general_country_list[index]
                                                    .country ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
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

enum _SearchResultType { Consultancy, Branch, Course }

class _SearchResultItem {
  final _SearchResultType type;
  final Consultancy_details_model? consultancy;
  final Branch_details_model? branch;
  final Course_details_model? course;

  _SearchResultItem(
      {required this.type, this.consultancy, this.branch, this.course});
}

// Dummy hexToColor function if you don't have yours
Color hexToColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

// Placeholder for course details screen - replace with your real screen
class CourseDetailsScreen extends StatelessWidget {
  final String token;
  final String consultancyId;
  final String branchId;
  final String courseId;
  final String courseTitle;

  const CourseDetailsScreen(
      {super.key,
        required this.token,
        required this.consultancyId,
        required this.branchId,
        required this.courseId,
        required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
      ),
      body: Center(
        child: Text(
            'Course details page for $courseTitle\nConsultancy ID: $consultancyId\nBranch ID: $branchId\nCourse ID: $courseId'),
      ),
    );
  }
}
