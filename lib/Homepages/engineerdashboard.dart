import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EngineerDashboardPage extends StatefulWidget {
  @override
  _EngineerDashboardPageState createState() => _EngineerDashboardPageState();
}

class _EngineerDashboardPageState extends State<EngineerDashboardPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _vacancyStream;
  Map<String, String> dropdownValues = {};

  @override
  void initState() {
    super.initState();
    _vacancyStream =
        FirebaseFirestore.instance.collection('Service_Request').snapshots();
  }

  void _saveStatusToFirestore(String documentId) async {
    final collectionRef =
        FirebaseFirestore.instance.collection('Service_Request');
    await collectionRef
        .doc(documentId)
        .update({'Status': dropdownValues[documentId]});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status saved to Firestore')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engineer Dashboard'),
        backgroundColor: Color.fromARGB(255, 182, 11, 11),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _vacancyStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No vacancy requests available'));
          }

          // Update the dropdown values map only with new document IDs
          for (final doc in snapshot.data!.docs) {
            final documentId = doc.id;
            if (!dropdownValues.containsKey(documentId)) {
              dropdownValues[documentId] = 'Pending';
            }
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vacancy = snapshot.data!.docs[index].data();
              final documentId = snapshot.data!.docs[index].id;
              final title = vacancy['Service Title'] ?? '';
              final city = vacancy['City'] ?? '';
              final streetNumber = vacancy['Street Number'] ?? '';
              final buildingNumber = vacancy['Building Number'] ?? '';
              final mapLink = vacancy['Google Map Link'] ?? '';
              final contactNumber = vacancy['Contact Number'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Title: $title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('City: $city'),
                            Text('Street Number: $streetNumber'),
                            Text('Building Number: $buildingNumber'),
                            Text('Map Link: $mapLink'),
                            Text('Contact Number: $contactNumber'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status:'),
                            DropdownButton<String>(
                              value: dropdownValues[documentId]!,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValues[documentId] = newValue!;
                                  print(
                                      'new value for $documentId: ${dropdownValues[documentId]}');
                                });
                              },
                              items: <String>[
                                'Pending',
                                'Visited',
                                'Completed',
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _saveStatusToFirestore(documentId),
                              child: Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
