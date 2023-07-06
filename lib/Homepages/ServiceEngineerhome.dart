import 'dart:io';

import 'package:b/b.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/Homepages/ServiceImageScrollview.dart';
import 'package:login_page/Homepages/engineerdashboard.dart';
import 'package:login_page/ServiceEngineerTasks/addservice1.dart';
import 'package:login_page/ServiceEngineerTasks/requestcheck.dart';
import 'package:login_page/ServiceEngineerTasks/updaterequest.dart';
import 'package:login_page/forgotpassword.dart';
import 'package:login_page/profilepage.dart';

class Serviceenghome extends StatefulWidget {
  @override
  State<Serviceenghome> createState() => _ServiceenghomeState();
}

class _ServiceenghomeState extends State<Serviceenghome> {
  String? Description = '';
  File? _imageFile;
  final picker = ImagePicker();
  String? _downloadURL;
  late int _totalNotifications;

  @override
  void initState() {
    // TODO: implement initState
    _totalNotifications = 0;
    super.initState();
    _retrieveProfilePicture();
    getData();
  }

  void _getUserDocument() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Customers')
              .where('email', isEqualTo: user_email)
              .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Engineer'),
        backgroundColor: Color(0xFFDB2227),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFDB2227), // Set the background color of the drawer
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EngineerDashboardPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Setting',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.white, // Set the icon color to white
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Services',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                child: ServiceImageScrollView(),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddService()));
                },
                child: Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Color(0xFFDB2227),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Add a service',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
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

  Future<void> getData() async {
    var user_id = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user_id)
          .get();
      if (snapshot.exists) {
        Description = snapshot.get('Description');
      } else {
        print('Description doesnot exist');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }
}
