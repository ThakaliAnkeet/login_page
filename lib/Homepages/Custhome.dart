import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/Homepages/ImageScrollview.dart';
import 'package:login_page/Homepages/Imagelistview.dart';
import 'package:login_page/Homepages/Report.dart';
import 'package:login_page/Homepages/ServiceImageScrollview.dart';
import 'package:login_page/Homepages/Setting.dart';
import 'package:login_page/Homepages/Userprofile.dart';
import 'package:login_page/Homepages/in_app_tour_target.dart';
import 'package:login_page/Homepages/location.dart';
import 'package:login_page/Homepages/servicelist.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CustHome extends StatefulWidget {
  @override
  State<CustHome> createState() => _CustHomeState();
}

class _CustHomeState extends State<CustHome> {
  bool showTutorial = true;
  bool showHouses = true;
  bool showServices = false;
  bool showMicrophoneAvatar = false;
  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  final _searchController = TextEditingController();
  var text = 'Hold the button and start speaking';

  final menukey = GlobalKey();
  final searchkey = GlobalKey();
  final profilekey = GlobalKey();
  final locationkey = GlobalKey();
  final reportkey = GlobalKey();
  final settingskey = GlobalKey();
  final logoutkey = GlobalKey();
  final navigationkey = GlobalKey();
  final scrollkey = GlobalKey();
  final listkey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark1;
  late TutorialCoachMark tutorialCoachMark2;

  void _initCusthometargets() {
    tutorialCoachMark1 = TutorialCoachMark(
        targets: CusthomeTargets(
            menukey: menukey,
            searchkey: searchkey,
            navigationkey: navigationkey,
            scrollkey: scrollkey,
            listkey: listkey),
        colorShadow: Color(0xFF858585),
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print('Completed');
        });
  }

  void _initsidebartargets() {
    tutorialCoachMark2 = TutorialCoachMark(
        targets: CusthomesideTargets(
            profilekey: profilekey,
            reportkey: reportkey,
            locationkey: locationkey,
            settingskey: settingskey,
            logoutkey: logoutkey),
        colorShadow: Color(0xFF858585),
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print('Completed');
        });
  }

  void _showHomeTour() {
    Future.delayed(const Duration(seconds: 1), () {
      tutorialCoachMark1.show(context: context);
    });
  }

  void _showsideTour() {
    Future.delayed(const Duration(seconds: 1), () {
      tutorialCoachMark2.show(context: context);
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstLoginStatus();
    _initCusthometargets();
    _initsidebartargets();
  }

  Future<void> checkFirstLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Customers')
          .doc(user.uid)
          .get();
      bool firstLogin = snapshot.data()?['firstlogin'] ?? true;

      if (firstLogin) {
        // Show the tutorial
        setState(() {
          showTutorial = true;
        });

        // Update the 'firstlogin' field in Firestore to false
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.uid)
            .update({'firstlogin': false});
      }
    }
  }

  void _showVoicePrompt() {
    bool isMicrophonePressed = false;
    String recognizedText = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Voice Prompt'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$text'),
                  GestureDetector(
                    onTapDown: (details) async {
                      if (!isListening) {
                        var available = await speechToText.initialize();
                        if (available) {
                          setState(() {
                            isListening = true;
                            speechToText.listen(onResult: (result) {
                              setState(() {
                                text = result.recognizedWords;
                              });
                            });
                          });
                        }
                      }
                    },
                    onTapUp: (details) async {
                      setState(() {
                        isListening = false;
                        isMicrophonePressed = false;
                      });
                      speechToText.stop();
                    },
                    child: AvatarGlow(
                      startDelay: Duration(milliseconds: 100),
                      glowColor: Colors.red,
                      endRadius: 60.0,
                      duration: Duration(milliseconds: 200),
                      repeat: false,
                      showTwoGlows: isMicrophonePressed,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: Icon(
                        Icons.mic,
                        size: 50,
                        color: isMicrophonePressed ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
              contentPadding: EdgeInsets.only(top: 16.0),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    text = 'Hold the button and start speaking';
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop(text);
                    _searchController.text = text;
                    text = 'Hold the button and start speaking';
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          recognizedText = text;
        });
      }
    });
  }

  void toggleView(bool housesVisible, bool servicesVisible) {
    setState(() {
      showHouses = housesVisible;
      showServices = servicesVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 182, 11, 11),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 182, 11, 11),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                key: profilekey,
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfile()),
                  );
                },
              ),
              ListTile(
                key: reportkey,
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ),
                title: Text(
                  'Report',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportPage()),
                  );
                },
              ),
              ListTile(
                key: locationkey,
                leading: Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationPage()),
                  );
                },
              ),
              ListTile(
                key: settingskey,
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                },
              ),
              ListTile(
                key: logoutkey,
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () => _signOut(context),
              ),
              ListTile(
                leading: Icon(Icons.question_mark_sharp, color: Colors.white),
                title: Text(
                  'Help',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () => _showsideTour(),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Row(
                children: [
                  Builder(builder: (BuildContext context) {
                    return IconButton(
                      key: menukey,
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        // Open drawer menu
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                  Expanded(
                    key: searchkey,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: showMicrophoneAvatar
                              ? CircleAvatar(
                                  radius: 15.0,
                                  child: Icon(Icons.mic),
                                )
                              : IconButton(
                                  onPressed: _showVoicePrompt,
                                  icon: Icon(Icons.mic))),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showHomeTour();
                    },
                    icon: Icon(Icons.question_mark_sharp),
                    color: Color(0xFFDB2227),
                  )
                ],
              ),
            ),
            Padding(
              key: navigationkey,
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      toggleView(true, false); // Show houses view
                    },
                    child: Container(
                      height: 45,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.15),
                        gradient: showHouses
                            ? SweepGradient(
                                colors: [
                                  Colors.orange,
                                  Color(0xffffffff),
                                ],
                                stops: [0, 1],
                                center: Alignment.topLeft,
                              )
                            : null,
                        color: showHouses ? null : Color(0xFFF7F7F7),
                      ),
                      child: Center(
                        child: Text(
                          'Apartments',
                          style: TextStyle(
                            color: showHouses ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleView(false, true); // Show services view
                    },
                    child: Container(
                      height: 45,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.15),
                        gradient: showServices
                            ? SweepGradient(
                                colors: [
                                  Colors.orange,
                                  Color(0xffffffff),
                                ],
                                stops: [0, 1],
                                center: Alignment.topLeft,
                              )
                            : null,
                        color: showServices ? null : Color(0xFFF7F7F7),
                      ),
                      child: Center(
                        child: Text(
                          'Services',
                          style: TextStyle(
                            color: showServices ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Near from you',
                  style: GoogleFonts.raleway(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (showServices)
              Padding(
                key: scrollkey,
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  child: ServiceImageScrollView(),
                ),
              ),
            if (showServices)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Best Services For You',
                    style: GoogleFonts.raleway(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (showServices)
              Padding(
                key: listkey,
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 300,
                  child: serviceimagelist(),
                ),
              ),
            if (showHouses)
              Padding(
                key: scrollkey,
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  child: ImageScrollView(),
                ),
              ),
            if (showHouses)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Best For You',
                    style: GoogleFonts.raleway(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (showHouses)
              Padding(
                key: listkey,
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 300,
                  child: imagelist(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/csignup');
  }
}
