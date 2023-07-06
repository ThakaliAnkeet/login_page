// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Apartment {
  String name;
  String address;
  bool isVacant;
  double price;

  Apartment(
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

class ApartmentsPage extends StatefulWidget {
  const ApartmentsPage({Key? key}) : super(key: key);

  @override
  _ApartmentsPageState createState() => _ApartmentsPageState();
}

class _ApartmentsPageState extends State<ApartmentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  List<Apartment> Apartments = [];
  bool isEditing = false;
  late int editingIndex;

  void addApartment() async {
    if (_formKey.currentState!.validate()) {
      final newApartment = Apartment(
        name: _nameController.text,
        address: _addressController.text,
        price: double.parse(_priceController.text),
        isVacant: true,
      );
      await FirebaseFirestore.instance
          .collection('apartments')
          .add(newApartment.toMap());
      setState(() {
        Apartments.add(newApartment);
        _nameController.clear();
        _addressController.clear();
      });
    }
  }

  void deleteApartment(int index) {
    setState(() {
      Apartments.removeAt(index);
    });
  }

  void updateApartment(int index) {
    setState(() {
      isEditing = true;
      editingIndex = index;
      _nameController.text = Apartments[index].name;
      _addressController.text = Apartments[index].address;
    });
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        Apartments[editingIndex].name = _nameController.text;
        Apartments[editingIndex].address = _addressController.text;
        Apartments[editingIndex].price = double.parse(_priceController.text);
        isEditing = false;
        _nameController.clear();
        _addressController.clear();
        _priceController.clear();
      });
    }
  }

  void toggleVacancy(int index) {
    setState(() {
      Apartments[index].isVacant = !Apartments[index].isVacant;
    });
    final String message = Apartments[index].isVacant
        ? 'Apartment is now vacant'
        : 'Apartment is now occupied';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartment Information'),
        backgroundColor: Colors.deepPurple,
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
                    decoration: InputDecoration(labelText: 'Apartment Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Apartment name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Apartment Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Apartment address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Apartment Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Apartment price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: isEditing ? saveChanges : addApartment,
                    child: Text(isEditing ? 'Save Changes' : 'Add Apartment'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: Apartments.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(Apartments[index].name),
                      subtitle: Text(Apartments[index].address),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => updateApartment(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteApartment(index),
                          ),
                          TextButton(
                            onPressed: () => toggleVacancy(index),
                            child: Text(Apartments[index].isVacant
                                ? 'Vacant'
                                : 'Occupied'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
