// ignore_for_file: file_names, unnecessary_this, library_private_types_in_public_api, prefer_const_constructors, avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String name;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.price,
  });
  Service copyWith({String? name, double? price}) {
    return Service(
      id: this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory Service.fromMap(String id, Map<String, dynamic> data) {
    final name = data['name'] as String;
    final price = data['price'] as double;
    return Service(id: id, name: name, price: price);
  }
}

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final CollectionReference _servicesCollection =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('services').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final services = snapshot.data!.docs
              .map((doc) =>
                  Service.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ListTile(
                title: Text(service.name),
                subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditServiceDialog(context, service),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteService(service.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddServiceDialog(context),
      ),
    );
  }

  Future<void> addService(Service service) async {
    try {
      await _servicesCollection.add({
        'name': service.name,
        'price': service.price,
      });
    } catch (e) {
      print('Error adding service: $e');
      rethrow;
    }
  }

  Future<void> _updateService(Service service) async {
    try {
      await _servicesCollection.doc(service.id).update({
        'name': service.name,
        'price': service.price,
      });
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  Future<void> _deleteService(String serviceId) async {
    try {
      await _servicesCollection.doc(serviceId).delete();
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }

  void _showAddServiceDialog(BuildContext context) {
    _serviceNameController.clear();
    _servicePriceController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  hintText: 'Service name',
                ),
              ),
              TextField(
                controller: _servicePriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Service price',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final name = _serviceNameController.text.trim();
                final price =
                    double.tryParse(_servicePriceController.text.trim()) ?? 0.0;
                final service = Service(id: '', name: name, price: price);
                addService(service).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditServiceDialog(BuildContext, Service service) {
    _serviceNameController.text = service.name;
    _servicePriceController.text = service.price.toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  hintText: 'Service name',
                ),
              ),
              TextField(
                controller: _servicePriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Service price',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final name = _serviceNameController.text.trim();
                final price =
                    double.tryParse(_servicePriceController.text.trim()) ?? 0.0;
                final updatedService =
                    service.copyWith(name: name, price: price);
                _updateService(updatedService).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
