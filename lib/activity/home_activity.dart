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

  List<Consultancy_details_model> filterConsultancy = [];
  List<General_country_model> filterCountry = [];

  bool isLoading = true;

  bool isSearchResultVisible = false;

  TextEditingController searchController = TextEditingController();

  final GlobalKey _searchBarKey = GlobalKey();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchAllData();
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
        filterConsultancy = consultancy_details_list;
        filterCountry = general_country_list;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  userDataModel? userName;

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

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filterConsultancy = consultancy_details_list;
        filterCountry = general_country_list;
        isSearchResultVisible = false;
      });
      return;
    }

    List<Consultancy_details_model> tempConsultancy = consultancy_details_list
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    List<General_country_model> tempCountry = general_country_list
        .where((c) =>
    c.country != null &&
        c.country!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filterConsultancy = tempConsultancy;
      filterCountry = tempCountry;
      isSearchResultVisible =
      tempConsultancy.isNotEmpty || tempCountry.isNotEmpty ? true : false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isSearchResultVisible = false;
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, bottom: 30, left: 25, right: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    '${userName?.name ?? "username"}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: 50,
                                  width: 116,
                                  child: Image.asset(
                                      'assets/images/iapply_logo.png')),
                            ],
                          ),
                        ),

                        // Search Bar Container (with Key for position)
                        Container(
                          key: _searchBarKey,
                          // color: hexToColor("7E6BA3"),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 10, top: 10),
                            child: SizedBox(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: searchController,
                                autofocus: false,
                                onChanged: (value) {
                                  filterSearch(value);
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(27),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1)),
                                  hintText: "Search for consultancy and country",
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  fillColor: Colors.white,
                                  filled: true,
                                  // suffixIcon: IconButton(
                                  //     onPressed: () {},
                                  //     icon: Icon(
                                  //       Icons.search,
                                  //       color: Theme.of(context).primaryColor,
                                  //     )),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Fixed Rows below the search bar and search results overlay
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
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        color: Color(0xFF7E6BA3),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color:Theme.of(context).canvasColor,
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            consultancy_details_list.length > 5 ? 5 : consultancy_details_list.length,
                            itemBuilder: (context, index) {
                              var consultancy = consultancy_details_list[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              consultancy_branch_activity(
                                                token: widget.token,
                                                id: consultancy.id,
                                                name: consultancy.name,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top:10,left: 5.0,right: 6),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 25 : 10,
                                      right: index == 4 ? 25 : 0,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 93,
                                          height: 93,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor, width: 2), // Border color here
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: consultancy.photo != null
                                                ? Image.network(
                                              consultancy.photo!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                                : Icon(
                                              Icons.business,
                                              size: 70,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            consultancy.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              );
                            },
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Countries',
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
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                        color: Color(0xFF7E6BA3),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: general_country_list.length > 5 ? 5 : general_country_list.length,
                            itemBuilder: (context, index) {
                              var country = general_country_list[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => general_country_activity(
                                        token: widget.token,
                                        id: country.id,
                                        country: country.country!,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, left: 5.0, right: 6),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 25 : 10,
                                      right: index == 4 ? 25 : 0,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 93,
                                          height: 93,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: country.map != null && country.map!.isNotEmpty
                                                ? Image.network(
                                              country.map!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                                : Icon(
                                              Icons.flag_rounded,
                                              size: 70,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            country.country ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Container(
                          height: 30,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),

                  // Floating search result container positioned absolutely over the scroll
                  if (isSearchResultVisible)
                    Positioned(
                      left: 25,
                      right: 25,
                      top: 175,
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Consultancy Results Title
                                if (filterConsultancy.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 5),
                                    child: Text(
                                      "Consultancies",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                // Consultancy List
                                ...filterConsultancy.map((consultancy) {
                                  return ListTile(
                                    leading: consultancy.photo != null
                                        ? ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      child: Image.network(
                                        consultancy.photo!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : Icon(
                                      Icons.business,
                                      color: Theme.of(context).primaryColor,
                                      size: 40,
                                    ),
                                    title: Text(
                                      consultancy.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        isSearchResultVisible = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  consultancy_branch_activity(
                                                    token: widget.token,
                                                    id: consultancy.id,
                                                    name: consultancy.name,
                                                  )));
                                    },
                                  );
                                }).toList(),

                                // Divider if both results present
                                if (filterConsultancy.isNotEmpty &&
                                    filterCountry.isNotEmpty)
                                  const Divider(),

                                // Country Results Title
                                if (filterCountry.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 5),
                                    child: Text(
                                      "Countries",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                // Country List
                                ...filterCountry.map((country) {
                                  return ListTile(
                                    leading: country.map != null &&
                                        country.map!.isNotEmpty
                                        ? ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      child: Image.network(
                                        country.map!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : Icon(
                                      Icons.flag_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: 40,
                                    ),
                                    title: Text(
                                      country.country ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        isSearchResultVisible = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  general_country_activity(
                                                    token: widget.token,
                                                    id: country.id,
                                                    country: country.country!,
                                                  )));
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
