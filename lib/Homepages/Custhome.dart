import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/CustomerTasks/requestforrent.dart';
import 'package:login_page/CustomerTasks/requestvisit.dart';
import 'package:login_page/CustomerTasks/viewvacantflat.dart';
import 'package:login_page/Homepages/3dview.dart';
import 'package:login_page/Homepages/ImageScrollview.dart';
import 'package:login_page/Homepages/Imagelistview.dart';
import 'package:login_page/Homepages/Report.dart';
import 'package:login_page/Homepages/ServiceImageScrollview.dart';
import 'package:login_page/Homepages/Setting.dart';
import 'package:login_page/Homepages/Userprofile.dart';
import 'package:login_page/Homepages/location.dart';
import 'package:login_page/Homepages/servicelist.dart';
import 'package:login_page/forgotpassword.dart';
import 'package:login_page/profilepage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class CustHome extends StatefulWidget {
  @override
  State<CustHome> createState() => _CustHomeState();
}

class _CustHomeState extends State<CustHome> {
  bool showHouses = true;
  bool showServices = false;
  bool showMicrophoneAvatar = false;
  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  final _searchController = TextEditingController();
  var text = 'Hold the button and start speaking';

  @override
  void initState() {
    super.initState();
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
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                onTap: () => _signOut(context),
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
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        // Open drawer menu
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                  Expanded(
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
                ],
              ),
            ),
            Padding(
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
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  height: 300,
                  child: serviceimagelist(),
                ),
              ),
            if (showHouses)
              Padding(
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
