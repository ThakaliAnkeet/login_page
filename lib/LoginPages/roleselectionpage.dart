import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/LoginPages/Custlogin.dart';
import 'package:flutter/services.dart';
import 'package:login_page/LoginPages/apartmentselectionpage.dart';

class RoleSelection extends StatefulWidget {
  @override
  _RoleSelectionState createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  TextEditingController _civilIdController = TextEditingController();
  bool _isTenantSelected = false;

  @override
  void dispose() {
    _civilIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Role Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select your role:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveRoleSelection('Customer');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustLogin()),
                );
              },
              child: Text('Customer'),
            ),
            ElevatedButton(
              onPressed: () async {
                await saveRoleSelection('Tenant');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustLogin()),
                );
              },
              child: Text('Tenant'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isTenantSelected = true;
                });
              },
              child: Text('Renter'),
            ),
            if (_isTenantSelected)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _civilIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Civil ID',
                    hintText: 'Enter your civil ID',
                  ),
                ),
              ),
            if (_isTenantSelected)
              ElevatedButton(
                onPressed: () async {
                  if (_civilIdController.text.length == 8 &&
                      _civilIdController.text != "00000000") {
                    if (await isCivilIdAvailable(_civilIdController.text)) {
                      await saveTenantRoleSelection(
                          'Renter', _civilIdController.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApartmentSelectionPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Duplicate Civil ID'),
                          content: Text(
                              'The entered Civil ID already exists. Please enter a unique Civil ID.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid Civil ID'),
                        content: Text('Please enter a valid 8-digit Civil ID.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> saveRoleSelection(String role) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(userId)
          .update({'role': role});
      print('Role selection saved successfully!');
    } catch (error) {
      print('Failed to save role selection: $error');
    }
  }

  Future<void> saveTenantRoleSelection(String role, String civilId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(userId)
          .update({'role': role, 'civilId': civilId});
      print('Role selection saved successfully!');
    } catch (error) {
      print('Failed to save role selection: $error');
    }
  }

  Future<bool> isCivilIdAvailable(String civilId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .where('civilId', isEqualTo: civilId)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (error) {
      print('Failed to check civil ID availability: $error');
      return false;
    }
  }
}
