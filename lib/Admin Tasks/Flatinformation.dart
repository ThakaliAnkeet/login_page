// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Flat {
  String name;
  String address;
  bool isVacant;
  double price;

  Flat(
      {required this.name,
      required this.address,
      required this.isVacant,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'isVacant': isVacant,
      'price': price,
    };
  }
}

class FlatInformationPage extends StatefulWidget {
  const FlatInformationPage({Key? key}) : super(key: key);

  @override
  _FlatInformationPageState createState() => _FlatInformationPageState();
}

class _FlatInformationPageState extends State<FlatInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  List<Flat> flats = [];
  bool isEditing = false;
  late int editingIndex;

  void addFlat() async {
    if (_formKey.currentState!.validate()) {
      final newFlat = Flat(
        name: _nameController.text,
        address: _addressController.text,
        price: double.parse(_priceController.text),
        isVacant: true,
      );
      await FirebaseFirestore.instance.collection('flats').add(newFlat.toMap());
      setState(() {
        flats.add(newFlat);
        _nameController.clear();
        _addressController.clear();
      });
    }
  }

  void deleteFlat(int index) {
    setState(() {
      flats.removeAt(index);
    });
  }

  void updateFlat(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      _nameController.text = flats[index].name;
      _addressController.text = flats[index].address;
    });
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        flats[editingIndex].name = _nameController.text;
        flats[editingIndex].address = _addressController.text;
        flats[editingIndex].price = double.parse(_priceController.text);
        isEditing = false;
        _nameController.clear();
        _addressController.clear();
        _priceController.clear();
      });
    }
  }

  void toggleVacancy(int index) {
    setState(() {
      flats[index].isVacant = !flats[index].isVacant;
    });
    final String message =
        flats[index].isVacant ? 'Flat is now vacant' : 'Flat is now occupied';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flat Information'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Flat Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter flat name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Flat Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter flat address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Flat Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter flat price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: isEditing ? saveChanges : addFlat,
                    child: Text(isEditing ? 'Save Changes' : 'Add Flat'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                  itemCount: flats.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(flats[index].name),
                        subtitle: Text(flats[index].address),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => updateFlat(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteFlat(index),
                            ),
                            TextButton(
                              onPressed: () => toggleVacancy(index),
                              child: Text(flats[index].isVacant
                                  ? 'Vacant'
                                  : 'Occupied'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
