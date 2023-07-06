import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/LoginPages/Custlogin.dart';

class ApartmentSelectionPage extends StatefulWidget {
  @override
  _ApartmentSelectionPageState createState() => _ApartmentSelectionPageState();
}

class _ApartmentSelectionPageState extends State<ApartmentSelectionPage> {
  String? selectedApartment;
  String? selectedFlat;

  List<String> apartments = List.generate(90, (index) => 'A${index + 1}');
  List<String> flats = [
    ...List.generate(90, (index) => 'F${index + 1}'),
    ...List.generate(40, (index) => 'G${index + 1}'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartment Selection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Apartment:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedApartment,
              hint: Text('Select Apartment'),
              onChanged: (newValue) {
                setState(() {
                  selectedApartment = newValue;
                });
              },
              items: apartments.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Flat:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedFlat,
              hint: Text('Select Flat'),
              onChanged: (newValue) {
                setState(() {
                  selectedFlat = newValue;
                });
              },
              items: flats.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveApartmentAndFlat,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveApartmentAndFlat() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      bool isApartmentAvailable =
          await checkApartmentAvailability(selectedApartment);
      bool isFlatAvailable = await checkFlatAvailability(selectedFlat);

      if (isApartmentAvailable && isFlatAvailable) {
        await FirebaseFirestore.instance
            .collection('Customers')
            .doc(userId)
            .update({
          'apartment': selectedApartment,
          'flat': selectedFlat,
        });
        print('Apartment and flat selection saved successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustLogin()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Selection Not Available'),
              content: Text(
                  'The selected apartment or flat is already assigned to another user.'),
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
      }
    } catch (error) {
      print('Failed to save apartment and flat selection: $error');
    }
  }

  Future<bool> checkApartmentAvailability(String? apartment) async {
    try {
      if (apartment == null) return false;

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .where('apartment', isEqualTo: apartment)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (error) {
      print('Failed to check apartment availability: $error');
      return false;
    }
  }

  Future<bool> checkFlatAvailability(String? flat) async {
    try {
      if (flat == null) return false;

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .where('flat', isEqualTo: flat)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (error) {
      print('Failed to check flat availability: $error');
      return false;
    }
  }
}
