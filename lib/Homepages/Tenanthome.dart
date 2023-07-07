import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/Homepages/ImageScrollview.dart';
import 'package:login_page/Homepages/ServiceImageScrollview.dart';
import 'package:login_page/Homepages/Setting.dart';
import 'package:login_page/Homepages/Userprofile.dart';
import 'package:login_page/Notification/receivenotification.dart';
import 'package:login_page/Renter/Addvacnacy.dart';
import 'package:login_page/forgotpassword.dart';
import 'package:login_page/profilepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert';

class TenantHome extends StatefulWidget {
  @override
  State<TenantHome> createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  String? Description = '';
  File? _imageFile;
  final picker = ImagePicker();
  String? _downloadURL;
  int? PhoneNumber;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoc();
    Future.delayed(Duration.zero, () {
      _retrieveProfilePicture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renter'),
        backgroundColor: Color(0xFFDB2227),
        actions: [
          GestureDetector(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddVacancy1()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFDB2227),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFDB2227),
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    if (_imageFile != null) {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Image.file(_imageFile!),
                          );
                        },
                      );
                    }
                  },
                  child: CircleAvatar(
                    minRadius: 30,
                    maxRadius: 40,
                    backgroundImage: _downloadURL != null
                        ? NetworkImage(_downloadURL!)
                        : null,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          _showImagePickerDialog(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Available Vacancies',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDB2227)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                height: 270,
                child: ImageScrollView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/esignup');
  }

  Future<void> _showImagePickerDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Take a picture'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text('Select from gallery'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNotification(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      final user = FirebaseAuth.instance.currentUser;
      final filePath = 'User_Profile_Picture/${user?.email}/profile';
      final storageRef = FirebaseStorage.instance.ref().child(filePath);

      await storageRef.putFile(_imageFile!);

      final downloadURL = await storageRef.getDownloadURL();
    }
  }

  Future<void> _retrieveProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    final filePath = 'User_Profile_Picture/${user?.email}/profile';
    final storageRef = FirebaseStorage.instance.ref().child(filePath);

    try {
      final downloadURL = await storageRef.getDownloadURL();
      setState(() {
        _downloadURL = downloadURL;
      });
    } catch (error) {
      // File does not exist in Firebase Storage
      final defaultStorageRef = FirebaseStorage.instance
          .ref()
          .child('User_Profile_Picture/blank-profile.png');
      final defaultDownloadURL = await defaultStorageRef.getDownloadURL();

      setState(() {
        _downloadURL =
            defaultDownloadURL; // Replace 'path_to_default_image' with the path to your default image
      });
    }
  }

  Future<void> getDoc() async {
    var user_id = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user_id)
          .get();
      if (snapshot.exists) {
        PhoneNumber = snapshot.get('contact');
      } else {
        print('Description doesnot exist');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  Future<void> _retrieveVacancyImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final filePath = 'Vacancy_Image/Vacancy/';
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    try {
      final downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        _downloadURL = downloadUrl;
      });
    } catch (e) {
      print('Error:$e');
    }
  }
}
