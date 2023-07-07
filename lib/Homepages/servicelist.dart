import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/Homepages/ImagedetailView.dart';
import 'package:login_page/Renter/requestforservice.dart';

class serviceimagelist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageContents(),
    );
  }

  Widget _buildPageContents() {
    return FutureBuilder<List<ImageData>>(
      future: fetchImageUrls(),
      builder: (BuildContext context, AsyncSnapshot<List<ImageData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCube(
            color: Color(0xFFDB2227),
            size: 50.0,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<ImageData> imageDataList = snapshot.data!;
          return ListView.builder(
            itemCount: imageDataList.length,
            itemBuilder: (context, index) {
              ImageData imageData = imageDataList[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CachedNetworkImage(
                          imageUrl: imageData.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => SpinKitFadingCube(
                            color: Color(0xFFDB2227),
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${imageData.fieldValue}',
                              style: GoogleFonts.raleway(
                                  fontSize: 17.1, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<dynamic>(
                              future: fetchData2(
                                  'Engineer_Services', imageData.imageName),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  Map<String, dynamic> vacancyData =
                                      snapshot.data;
                                  String startprice =
                                      vacancyData['Starting Price'];
                                  String endprice = vacancyData['End Price'];
                                  return Text(
                                    'Price: $startprice-$endprice', // Replace with your price data
                                    style: GoogleFonts.raleway(
                                      fontSize: 17.1,
                                      color: Color(0xFF4EFB12),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestForService(
                                            baseID: '',
                                            imagename: '',
                                          )),
                                );
                              },
                              child: Text('Inquire Now'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFDB2227),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.69),
                                ),
                                minimumSize: Size(133, 34),
                              ),
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
        }
      },
    );
  }

  Future<List<ImageData>> fetchImageUrls() async {
    final user_email = FirebaseAuth.instance.currentUser!.email;

    final ListResult result = await firebase_storage.FirebaseStorage.instance
        .ref('Service_Image/Service/')
        .listAll();

    final List<ImageData> imageList = [];
    for (final Reference ref in result.items) {
      final String imageUrl = await ref.getDownloadURL();
      final String imageName = ref.name;
      dynamic fieldValue =
          await fetchData('Engineer_Services', imageName, 'Title');

      imageList.add(ImageData(
        imageUrl: imageUrl,
        imageName: imageName,
        fieldValue: fieldValue,
      ));
    }

    return imageList;
  }

  Future<dynamic> fetchData(
      String collectionName, String documentID, String fieldName) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentID)
          .get();
      if (snapshot.exists) {
        dynamic fieldValue =
            (snapshot.data() as Map<String, dynamic>)[fieldName];
        return fieldValue;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchData2(
      String collectionName, String documentID) async {
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
}

class ImageData {
  final String imageUrl;
  final String imageName;
  final dynamic fieldValue;

  ImageData({
    required this.imageUrl,
    required this.imageName,
    required this.fieldValue,
  });
}
