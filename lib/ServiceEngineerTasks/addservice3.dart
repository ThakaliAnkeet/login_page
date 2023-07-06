import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:login_page/Homepages/ServiceEngineerhome.dart';

class AddService3 extends StatefulWidget {
  const AddService3({Key? key}) : super(key: key);

  @override
  State<AddService3> createState() => _AddService3State();
}

class _AddService3State extends State<AddService3> {
  final _key = GlobalKey<FormState>();

  String? _fileUrl;
  bool _isUploading = false;
  String _uploadMessage = '';

  final FilePicker _filePicker = FilePicker.platform;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Configuration'),
        backgroundColor: Color.fromARGB(255, 182, 11, 11),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Service Metadata',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _fileUrl != null
                      ? Text(
                          'File URL: $_fileUrl',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 16),

                  // Button to upload a file
                  ElevatedButton(
                    onPressed: () => _selectFile(),
                    child: _isUploading
                        ? CircularProgressIndicator()
                        : Text('Upload a .obj File'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: GestureDetector(
                      onTap: () {
                        getDataFromFirebase();
                        update();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFDB2227),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _uploadMessage,
                    style: TextStyle(
                      color: _uploadMessage.startsWith('Error')
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
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

  Future<void> _selectFile() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    setState(() {
      _isUploading = true;
      _uploadMessage = 'Uploading file...';
    });

    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      final filePath = file.path;
      final fileName = file.name;

      try {
        // Get the ID from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Engineer_Services')
            .doc(user_email)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          dynamic ID = data['ID'];

          // Rename the file using the ID value
          var newFileName = '$ID.obj';

          // Upload the file to Firebase Storage
          final storageRef = FirebaseStorage.instance.ref();
          final task = storageRef
              .child('Service_Files/$user_email/$newFileName')
              .putFile(File(filePath!));

          await task.whenComplete(() async {
            // Update the file URL and message
            final fileUrl = await storageRef
                .child('Service_Files/$user_email/$newFileName')
                .getDownloadURL();
            setState(() {
              _fileUrl = fileUrl;
              _isUploading = false;
              _uploadMessage = 'File uploaded successfully!';
            });

            print('File URL: $_fileUrl');
          });
        } else {
          print('Document does not exist');
        }
      } catch (error) {
        setState(() {
          _isUploading = false;
          _uploadMessage = 'Error uploading file: $error';
        });
        print('Error uploading file: $error');
      }
    } else {
      setState(() {
        _isUploading = false;
        _uploadMessage = 'No file selected.';
      });
    }
  }

  Future<void> getDataFromFirebase() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Engineer_Services')
          .doc(user_email)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        dynamic ID = data['ID'];
        await FirebaseFirestore.instance
            .collection('Engineer_Services')
            .doc(ID)
            .set(data);
        await copyAndPasteFile('Service_Image/$user_email/Service Image',
            'Service_Image/Service/$ID');
        print('Data saved successfully');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> copyAndPasteFile(
      String sourcePath, String destinationPath) async {
    try {
      final storage = FirebaseStorage.instance;
      final sourceReference = storage.ref().child(sourcePath);
      final sourceDownloadUrl = await sourceReference.getDownloadURL();
      final destinationReference = storage.ref().child(destinationPath);
      final sourceBytes = await sourceReference.getData();

      await destinationReference.putData(Uint8List.fromList(sourceBytes!));
      print('File copied successfully!');
    } catch (e) {
      print('Error copying file: $e');
    }
  }

  void update() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Serviceenghome()));
  }
}
