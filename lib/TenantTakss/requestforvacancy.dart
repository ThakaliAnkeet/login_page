import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:login_page/Homepages/Custhome.dart';
import 'package:login_page/Homepages/ImageScrollview.dart';
import 'package:login_page/Homepages/ServiceEngineerhome.dart';
import 'package:login_page/Homepages/Tenanthome.dart';
import 'package:login_page/Notification/sendnotification.dart';

class RequestForVacancy extends StatelessWidget {
  RequestForVacancy(
      {super.key,
      required this.baseID,
      required this.imagename,
      required this.token});
  final String? baseID;
  final String? imagename;
  final String token;
  String? FirstName;
  String? LastName;
  String? contact;

  List<mailData> mailDataList = [];

  final _key = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  final _cityController = TextEditingController();

  final _streetController = TextEditingController();

  final _buildingController = TextEditingController();

  final _mapController = TextEditingController();

  final _contactController = TextEditingController();

  String errorMessage = '';
  int count = 0;
  int? PhoneNum;
  String? userID;
  String? userbaseID;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var user_email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Request'),
        backgroundColor: Color.fromARGB(255, 182, 11, 11),
      ),
      body: FutureBuilder<dynamic>(
          future: fetchData('Vacancy', imagename!),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              Map<String, dynamic> vacancyData = snapshot.data;
              return Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fill Out Your Information',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 20, color: Color(0xFFDB2227)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // City
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _firstnameController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your first name'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _lastnameController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your last name'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // City
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _cityController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter the name of your City'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Street Number
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _streetController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your Street Number'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Building Number
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _buildingController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your building Number'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Google Maps Link
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: _mapController,
                                validator: validateCity,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Provide a google maps link of your desired location'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Immediate Contact
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: IntlPhoneField(
                                controller: _contactController,
                                validator: validatecontact,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Sign-in button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: GestureDetector(
                            onTap: () async {
                              Map<String, dynamic> vacancyData = snapshot.data;

                              if (_key.currentState!.validate()) {
                                try {
                                  await addServiceDetails(
                                      _firstnameController.text.trim(),
                                      _lastnameController.text.trim(),
                                      _cityController.text.trim(),
                                      _streetController.text.trim(),
                                      _buildingController.text.trim(),
                                      _mapController.text.trim(),
                                      _contactController.text.trim(),
                                      vacancyData['Title'],
                                      vacancyData['ID'],
                                      vacancyData['baseID'],
                                      userID,
                                      userbaseID);
                                  errorMessage = '';
                                } on FirebaseException catch (error) {
                                  errorMessage = error.message!;
                                }
                              }

                              getDoc();
                              final List<mailData> recipients =
                                  await getemail();
                              final List<String> recipientEmails = recipients
                                  .map((mailData) => mailData.mail)
                                  .toList();

                              sendEmail(recipientEmails);
                            },
                            child: Container(
                              padding: EdgeInsets.all(25),
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
              );
            }
          }),
    );
  }

  Future<void> sendEmail(List<String> recipientEmails) async {
    var user_ID = FirebaseAuth.instance.currentUser!.uid;
    FirstName = await getFieldValue(user_ID, 'first name');
    LastName = await getFieldValue(user_ID, 'last name');

    final Email email = Email(
      body:
          ' A vacancy request hase been sent by $FirstName $LastName. Please contact as soon as possible ${_contactController.text.trim()}',
      subject: 'Vacancy Request',
      recipients: recipientEmails,
    );
    try {
      await FlutterEmailSender.send(email);
      print('Email sent successfully');
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  Future<String> getFieldValue(String documentId, String fieldName) async {
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

  Future<String> getcurrentUserToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final userToken = fcmToken;
    String sender_token = userToken!;
    return sender_token;
  }

  String? validateCity(String? value) {
    if (value!.isEmpty) {
      return ('Please fill out the field');
    }
  }

  Future<void> addServiceDetails(
      String firstname,
      String lastname,
      String City,
      String Street_Number,
      String Building_Number,
      String Map_link,
      String contact,
      String title,
      String ID,
      String? baseID,
      String? userID,
      String? userbaseID) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    var docRef = FirebaseFirestore.instance
        .collection('Vacancy_Request')
        .doc(user_email);
    await docRef.set({
      'FirstName': firstname,
      'LastName': lastname,
      'City': City,
      'Street Number': Street_Number,
      'Building Number': Building_Number,
      'Google Map Link': Map_link,
      'Contact Number': contact,
      'Vacancy Title': title,
      'ID': ID,
      'baseID': baseID,
      'userID': userID,
      'userbaseID': userbaseID
    });
    var newDocRef =
        FirebaseFirestore.instance.collection('Vacancy_Request').doc(userID);
    var snapshot = await docRef.get();
    if (snapshot.exists) {
      await newDocRef.set(snapshot.data()!);
    }
  }

  Future<void> getDoc() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Vacancy_Request')
          .doc(user_email)
          .get();
      if (snapshot.exists) {
        dynamic phoneNumValue = snapshot.get('Contact Number');
        PhoneNum = int.tryParse(phoneNumValue) ?? null;
        if (PhoneNum != null) {
          userbaseID = PhoneNum!.toRadixString(16);
          String existingID = await checkExistingID(userbaseID!);
          if (existingID.isNotEmpty) {
            int existingCount =
                int.tryParse(existingID.substring(userbaseID!.length + 1)) ?? 0;
            count = existingCount + 1;
          } else {
            count = 0;
          }
          userID = '${userbaseID! + '+$count'}';
        } else {
          print('Phone Number is null');
        }
      } else {
        print('Description does not exist');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  Future<void> getDataFromFirebase() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    await getDoc();

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Vacancy_Request')
          .doc(user_email)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        dynamic ID = data['ID'];
        print(data);
        await FirebaseFirestore.instance
            .collection('Vacancy_request')
            .doc(userID)
            .set(data);
        print('Data saved successfully');
      } else {
        print('Document doesnot exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchData(
      String collectionName, String documentID) async {
    await getDoc();
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentID)
          .get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('Document does not exist');
        return {};
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return {};
    }
  }

  Future<String> checkExistingID(String userbaseID) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Vacancy_Request')
        .where('userID', isGreaterThanOrEqualTo: userbaseID)
        .where('userID', isLessThan: userbaseID + '\uf8ff')
        .get();
    if (querySnapshot.size > 0) {
      // Sort the IDs to get the largest existing ID
      List<String> sortedIDs =
          querySnapshot.docs.map((doc) => doc.get('userID') as String).toList();
      sortedIDs.sort();
      return sortedIDs.last;
    }

    return '';
  }

  FutureOr<String?> validatecontact(PhoneNumber? formcontact) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Customers')
              .where('contact', isEqualTo: _contactController)
              .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {}
      if (querySnapshot == _contactController) {
        print("The given contact number already exists");
      }
    } catch (e) {
      print(e);
    }
  }
}

Future<dynamic> fetchName(
    String collectionName, String documentID, String fieldName) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentID)
        .get();
    if (snapshot.exists) {
      dynamic fieldValue = (snapshot.data() as Map<String, dynamic>)[fieldName];
      return fieldValue;
    } else {
      print('Document doesnot exist');
      return null;
    }
  } catch (e) {
    print('Error retieving data:$e');
    return null;
  }
}

class mailData {
  final String mail;
  mailData(this.mail);
  @override
  String toString() {
    return mail;
  }
}

Future<List<mailData>> getemail() async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('Customers')
          .where('role', isEqualTo: 'Tenant')
          .get();

  final List<mailData> mailDataList = [];

  for (final doc in querySnapshot.docs) {
    final email = doc.data()['email'] as String;
    mailDataList.add(mailData(email));
  }

  return mailDataList;
}
