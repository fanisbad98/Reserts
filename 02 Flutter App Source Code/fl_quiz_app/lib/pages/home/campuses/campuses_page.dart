import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/constant.dart';
import 'package:fl_quiz_app/models/campuses_model.dart';
import 'package:fl_quiz_app/pages/home/campuses/campus_donation.dart';
import 'package:fl_quiz_app/utils/widgets.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:fl_quiz_app/services/api_services.dart';

class CampusesPage extends StatefulWidget {
  const CampusesPage({Key? key}) : super(key: key);
  
  @override
  CampusesPageState createState() => CampusesPageState();
}

class CampusesPageState extends State<CampusesPage> {
  List<Campuses> campuses = [];
  bool isJoinedCampus = false;

  @override
  void initState() {
    super.initState();
    _fetchAllCampuses();
  }

  Future<void> _fetchAllCampuses() async {
    try {
      final List<Campuses> fetchedCampuses = await ApiServices.fetchAllCampuses(context);
      setState(() {
        campuses = fetchedCampuses;
      });
      for (Campuses campus in campuses) {
        if (campus.members.contains(global.userId)) {
          setState(() {
            isJoinedCampus = true;
          });
          break;
        }
      }
    } catch (e) {
      print('Failed to fetch campuses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: campuses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemCount: campuses.length,
              itemBuilder: (context, index) {
                final campus = campuses[index];
                final bool isMember = campus.members.contains(global.userId);
                final bool canJoin = !isMember && !isJoinedCampus;
                return GestureDetector(
                  onTap: () {
                    _showCampusMembersDialog(context, campus);
                  },
                  child: Card(
                    elevation: 8, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                           Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campus.name,
                                  style:const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),  
                                Row(
                                  children: [
                                    Text(
                                      '${campus.points}',  
                                      style: color0SemiBold18
                                    ),
                                    const SizedBox(width: 5),
                                    Image.asset(
                                      pointsImage, 
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (isMember)
                            ElevatedButton(
                              onPressed: () {
                                _leaveCampus(campus.id);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red), // Adjust color as needed
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              ),
                              child: const Text('Leave', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          if (canJoin)
                            ElevatedButton(
                              onPressed: () {
                                _joinCampus(campus.id);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(color5E), 
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              ),
                              child: const Text('Join', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showSortOptions(context);
            },
            backgroundColor: color5E,
            child: const Icon(Icons.sort, color: colorC3),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              showCampusDonationDialog(context);
            },
            backgroundColor: color5E,
            child: const Icon(Icons.monetization_on, color: Colors.black),
          ),
        ],
      ),
    );
  }

  PreferredSize appBarMethod() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Campuses', withBackArrow: false),
    );
  }

  void showCampusDonationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CampusDonation(
            onDonationSuccess: _onDonationSuccess,
          ),
        ),
      ),
    );
  }

  void _onDonationSuccess() {
    _fetchAllCampuses();
  }

  void _showCampusMembersDialog(BuildContext context, Campuses campus) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), 
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(16),  
            boxShadow: [  
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),  
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Members of ${campus.name}',
                style: blackBold20
              ),
              const SizedBox(height: 12),  
              FutureBuilder(
                future: _fetchMemberNames(campus.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(), 
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Error fetching members: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),  
                      ),
                    );
                  } else {
                    List<String> memberNames = snapshot.data ?? [];
                    if (memberNames.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'No members found for this campus yet.',
                          style: TextStyle(color: Colors.grey[600]),  
                        ),
                      );
                    }
                    return Column(
                      children: List.generate(memberNames.length, (index) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0), 
                              title: Text(
                                memberNames[index],
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500,  
                                  color: Colors.black87,  
                                ),
                              ),
                            ),
                            if (index < memberNames.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(
                                  color: Colors.grey[400],  
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ),
                          ],
                        );
                      }),
                    );
                  }
                },
              ),
              const SizedBox(height: 12), 
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      color: color5E,  
                      fontWeight: FontWeight.w600,  
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Future<List<String>> _fetchMemberNames(String campusId) async {
    try {
      return await ApiServices.fetchMembersNames(campusId, context);
    } catch (e) {
      print('Error fetching member names: $e');
      return [];
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'Sort by Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  sortCampusesByName();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Campuses have been sorted by name.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Sort by Points',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  sortCampusesByPoints();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Campuses have been sorted by points.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void sortCampusesByName() {
    setState(() {
      campuses.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void sortCampusesByPoints() {
    setState(() {
      campuses.sort((a, b) => b.points.compareTo(a.points));
    });
  }

  void _joinCampus(String campusId) async {
    try {
      String userId = global.userId ?? "";
      await ApiServices.joinCampus(campusId, userId, context);
      _fetchAllCampuses();
    } catch (e) {
      print('Error joining campus: $e');
    }
  }

  void _leaveCampus(String campusId) async {
    try {
      String userId = global.userId ?? "";
      await ApiServices.leaveCampus(campusId, userId, context);
      setState(() {
        isJoinedCampus = false;
      });
      _fetchAllCampuses(); 
    } catch (e) {
      print('Error leaving campus: $e');
    }
  }
}