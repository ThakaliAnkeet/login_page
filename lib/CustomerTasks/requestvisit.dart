import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/Homepages/Custhome.dart';
import 'package:login_page/Homepages/Tenanthome.dart';

class Customerservicerequest extends StatefulWidget {
  const Customerservicerequest({super.key});

  @override
  State<Customerservicerequest> createState() => _CustomerservicerequestState();
}

class _CustomerservicerequestState extends State<Customerservicerequest> {
  final _key = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _mapController = TextEditingController();
  final _contactController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Request'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: SafeArea(
        child: Center(
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
                      style: GoogleFonts.bebasNeue(fontSize: 20),
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
                        child: TextFormField(
                          controller: _contactController,
                          validator: validateCity,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your immediate contact number'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sign-in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: update,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color(0xFFDB2227),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text('Submit',
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
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

  String? validateCity(String? value) {
    if (value!.isEmpty) {
      return ('Please fill out the field');
    }
  }

  Future update() async {
    if (_key.currentState!.validate()) {
      try {
        addServiceDetails(
          _cityController.text.trim(),
          _streetController.text.trim(),
          _buildingController.text.trim(),
          _mapController.text.trim(),
          _contactController.text.trim(),
        );
        errorMessage = '';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CustHome()));
      } on FirebaseException catch (error) {
        errorMessage = error.message!;
      }
      setState(() {});
    }
  }

  Future addServiceDetails(String City, String Street_Number,
      String Building_Number, String Map_link, String contact) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    await FirebaseFirestore.instance
        .collection('Service_Request')
        .doc(user_email)
        .set({
      'City': City,
      'Street Number': Street_Number,
      'Building Number': Building_Number,
      'Google Map Link': Map_link,
      'Contact Number': contact
    });
  }
}
