import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import 'package:login_page/Homepages/Tenanthome.dart';

class AddVacancy3 extends StatefulWidget {
  const AddVacancy3({Key? key}) : super(key: key);

  @override
  State<AddVacancy3> createState() => _AddVacancy3State();
}

class _AddVacancy3State extends State<AddVacancy3> {
  final _key = GlobalKey<FormState>();

  String? _imageUrl;

  final FilePicker _filePicker = FilePicker.platform;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Configuration'),
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
                      'Vacancy Metadata',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _imageUrl != null
                      ? Image.network(
                          _imageUrl!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  SizedBox(height: 16),

                  // Button to upload an image
                  ElevatedButton(
                    onPressed: () => _selectFile(),
                    child: Text('Upload a obj Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDB2227),
                    ),
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

    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      final filePath = file.path;
      final fileName = 'Vacancy_3D_File';
      final storagePath = 'Vacancy_Files/$user_email/$fileName';

      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final task = storageRef.putFile(File(filePath!));

      await task.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = downloadUrl;
        });
      }).catchError((error) {
        print('File upload Error: $error');
      });
    }
  }

  Future<void> getDataFromFirebase() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Vacancy')
          .doc(user_email)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        dynamic ID = data['ID'];
        await FirebaseFirestore.instance
            .collection('Vacancy')
            .doc(ID)
            .set(data);
        await copyAndPasteFile('Vacancy_Image/$user_email/Vacancy Image',
            'Vacancy_Image/Vacancy/$ID');
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
      print('Image copied successfully!');
    } catch (e) {
      print('Error copying image: $e');
    }
  }

  void update() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TenantHome()),
    );
  }
}
