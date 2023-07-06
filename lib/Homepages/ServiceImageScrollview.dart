import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_page/Homepages/ImagedetailView.dart';
import 'package:login_page/Homepages/ServieImageDetailView.dart';

class ServiceImageScrollView extends StatelessWidget {
  List<ImageData> imageDataList = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<ImageData>>(
      future: fetchImageUrls(),
      builder: (BuildContext context, AsyncSnapshot<List<ImageData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCube(
            color: Color(0xFFDB2227),
            size: 50.0,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          imageDataList = snapshot.data!;
          return Container(
            height: screenHeight * 0.35,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: imageDataList.map((imageData) {
                      bool isSelected =
                          imageDataList.indexOf(imageData) == currentIndex;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceImageDetailView(
                                imageUrl: imageData.imageUrl,
                                imageName: imageData.imageName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.35,
                          margin: EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageData.imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0, 3))
                                    ],
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    SpinKitFadingCube(
                                  color: Color(0xFFDB2227),
                                  size: 50.0,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 20,
                                child: Text(
                                  '${imageData.fieldValue}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                right: 25,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ImageData {
  final String imageUrl;
  final String imageName;
  final dynamic fieldValue;

  ImageData(
      {required this.imageUrl,
      required this.imageName,
      required this.fieldValue});
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
        imageUrl: imageUrl, imageName: imageName, fieldValue: fieldValue));
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
