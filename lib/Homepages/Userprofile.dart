import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _imageFile;
  final picker = ImagePicker();
  String? _downloadURL;

  String? firstName;
  String? lastName;
  String? email;
  String? contact;
  int? age;
  String? role;
  @override
  void initState() {
    super.initState();
    _retrieveProfilePicture();
    retrieveFieldValues();
  }

  Future<void> retrieveFieldValues() async {
    final user_id = FirebaseAuth.instance.currentUser!.uid;
    String documentId = user_id;

    try {
      firstName = await getFieldValue(documentId, 'first name');
      lastName = await getFieldValue(documentId, 'last name');
      email = await getFieldValue(documentId, 'email');
      contact = await getFieldValue(documentId, 'contact');
      String ageString = await getFieldValue(documentId, 'age');
      age = int.tryParse(ageString);
      role = await getFieldValue(documentId, 'role');

      setState(() {
        // Update the UI with the retrieved field values
        firstName = firstName;
        lastName = lastName;
        email = email;
        contact = contact;
        age = age;
        role = role;
      });
    } catch (e) {
      // Handle error
      print('Error retrieving field values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Color.fromARGB(255, 182, 11, 11),
        shadowColor: Color(0xFF858585),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            ListTile(
              leading: Icon(Icons.person),
              title: Text('First Name'),
              subtitle: Text(firstName ?? 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Last Name'),
              subtitle: Text(lastName ?? 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email ?? 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact'),
              subtitle: Text(contact ?? 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Age'),
              subtitle: Text(age != null ? age.toString() : 'Loading...'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Role'),
              subtitle: Text(role ?? 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getFieldValue(String? documentId, String fieldName) async {
    var user_id = await FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('Customers').doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        String fieldValue = data[fieldName].toString();
        return fieldValue;
      } else {
        // Document does not exist
        return '';
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error retrieving field value: $e');
      return '';
    }
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

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      final user = FirebaseAuth.instance.currentUser!;
      final filePath = 'User_Profile_Picture/${user.email}/profile';
      final storageRef = FirebaseStorage.instance.ref().child(filePath);

      await storageRef.putFile(_imageFile!);

      final downloadURL = await storageRef.getDownloadURL();
    }
  }

  Future<void> _retrieveProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser!;
    final filePath = 'User_Profile_Picture/${user.email}/profile';
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
        _downloadURL = defaultDownloadURL;
      });
    }
  }
}
