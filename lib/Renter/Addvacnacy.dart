import 'package:b/b.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/ServiceEngineerTasks/addservice2.dart';
import 'package:login_page/Renter/Addvacancy2.dart';
import 'package:base58check/base58check.dart';

class AddVacancy1 extends StatefulWidget {
  const AddVacancy1({super.key});

  @override
  State<AddVacancy1> createState() => _AddVacancy1State();
}

class _AddVacancy1State extends State<AddVacancy1> {
  final _key = GlobalKey<FormState>();
  final _TitleController = TextEditingController();
  String Categorydropdownvalue = 'Category';
  String errorMessage = '';
  int? PhoneNum;
  String? ID;
  String? baseID;
  int count = 0;
  var items = ['Category', '1 BHK', '2 BHK', '3 BHK', '4 BHK', '5 BHK'];

  Future addVacancyDetails(
      String ID, String Title, String VacancyCategory, String baseID) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    final user_id = FirebaseAuth.instance.currentUser!.uid;
    final userToken = await getUserToken();

    await FirebaseFirestore.instance.collection('Vacancy').doc(user_email).set({
      'ID': ID,
      'Title': Title,
      'Vacancy Category': VacancyCategory,
      'baseID': baseID,
      'token': userToken,
      'email': user_email,
      'contact': await getFieldValue(user_id, 'contact'),
      'first name': await getFieldValue(user_id, 'first name'),
      'last name': await getFieldValue(user_id, 'last name'),
    });
  }

  Future<void> processForm() async {
    await getDoc();
    if (Categorydropdownvalue == 'Category') {
      // Show AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select a Category'),
            content: Text('Please select a category from the dropdown.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      update();
    }
  }

  Future update() async {
    if (_key.currentState!.validate()) {
      try {
        if (ID != null) {
          addVacancyDetails(ID!.toString(), _TitleController.text.trim(),
              Categorydropdownvalue, baseID.toString());
          errorMessage = '';
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AddVacancy2()));
        } else {
          print('ID is null');
        }
      } on FirebaseException catch (error) {
        errorMessage = error.message!;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Configuration'),
        backgroundColor: Color.fromARGB(255, 182, 11, 11),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Initial Details',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          controller: _TitleController,
                          validator: validateTitle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            DropdownButton(
                              value: Categorydropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  child: Text(items),
                                  value: items,
                                );
                              }).toList(),
                              onChanged: (String? newvalue) {
                                setState(() {
                                  Categorydropdownvalue = newvalue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: GestureDetector(
                      onTap: processForm,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFDB2227),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Next',
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
              )),
        ),
      ),
    );
  }

  String? validateTitle(String? value) {
    if (value!.isEmpty) {
      return 'Enter a title';
    }
    return null;
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

  Future<void> getDoc() async {
    var user_id = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user_id)
          .get();
      if (snapshot.exists) {
        PhoneNum = snapshot.get('contact');
        if (PhoneNum != null) {
          baseID = PhoneNum?.toRadixString(16) ?? '';
          String existingID = await checkExistingID(baseID!);
          if (existingID.isNotEmpty) {
            int existingCount =
                int.tryParse(existingID.substring(baseID!.length + 1)) ?? 0;
            count = existingCount + 1;
          } else {
            count = 0;
          }
          ID = '$baseID+$count';
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

  Future<String> checkExistingID(String baseID) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Vacancy')
        .where('ID', isGreaterThanOrEqualTo: baseID)
        .where('ID', isLessThan: baseID + '\uf8ff')
        .get();

    if (querySnapshot.size > 0) {
      // Sort the IDs to get the largest existing ID
      List<String> sortedIDs =
          querySnapshot.docs.map((doc) => doc.get('ID') as String).toList();
      sortedIDs.sort();
      return sortedIDs.last;
    }

    return '';
  }

  Future<String?> getUserToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final userToken = fcmToken;
    return userToken;
  }
}
