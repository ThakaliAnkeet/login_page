import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/Homepages/3dview.dart';
import 'package:login_page/Homepages/Report.dart';
import 'package:login_page/Homepages/in_app_tour_target.dart';
import 'package:login_page/Renter/requestforservice.dart';
import 'package:login_page/Renter/requestforvacancy.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetailView extends StatefulWidget {
  ImageDetailView({
    Key? key,
    required this.imageUrl,
    required this.imageName,
  }) : super(key: key);

  final String imageUrl;
  final String imageName;

  @override
  State<ImageDetailView> createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView> {
  final imagekey = GlobalKey();

  final desckey = GlobalKey();

  final phonekey = GlobalKey();

  final threedkey = GlobalKey();

  final pricekey = GlobalKey();

  final inquirekey = GlobalKey();

  late TutorialCoachMark _tutotrialCoachMark;

  void _initDetailtargers() {
    _tutotrialCoachMark = TutorialCoachMark(
        targets: vacancyDetailTargets(
          imagekey: imagekey,
          desckey: desckey,
          phonekey: phonekey,
          threedkey: threedkey,
          pricekey: pricekey,
          inquirekey: inquirekey,
        ),
        colorShadow: Color(0xFF858585),
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print('Completed');
        });
  }

  void _showdetailTour() {
    Future.delayed(const Duration(seconds: 1), () {
      _tutotrialCoachMark.show(context: context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initDetailtargers();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final String phoneassetName = 'asset/phone.svg';
    final Widget phonesvg = SvgPicture.asset(
      phoneassetName,
      height: 50,
      width: 50,
    );
    final String msgassetName = 'asset/message.svg';
    final Widget msgsvg = SvgPicture.asset(
      msgassetName,
      height: 50,
      width: 50,
    );

    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: fetchData('Vacancy', widget.imageName),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> vacancyData = snapshot.data;

            // Phone Icon and Phone Number
            Widget phoneSection = Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: phonesvg,
                  iconSize: 50,
                  onPressed: () {
                    String phoneNumber = vacancyData['contact'];
                    launch('tel:$phoneNumber');
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestForVacancy(
                          baseID: vacancyData['baseID'],
                          imagename: widget.imageName,
                          token: vacancyData['token'],
                        ),
                      ),
                    );
                  },
                  icon: msgsvg,
                  iconSize: 50,
                )
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        key: imagekey,
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.95,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
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
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 16,
                      child: IconButton(
                        icon: Icon(Icons.bookmark_border),
                        color: Colors.white,
                        onPressed: () {
                          // Handle bookmark button action
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 16,
                      child: Text(
                        '${vacancyData['Title']}',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 16,
                      child: Text(
                        '${vacancyData['Vacancy Category']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        _showdetailTour();
                      },
                      icon: Icon(Icons.question_mark_sharp),
                      color: Color(0xFFDB2227),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  key: desckey,
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                  child: ReadMoreText(
                    '${vacancyData['Scope']}',
                    trimLines: 2,
                    colorClickableText: Colors.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: 'Show Less',
                    moreStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    style: TextStyle(
                      color: Color(0xFF858585),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FutureBuilder<String>(
                          future: fetchUserImage(vacancyData['email']),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 42,
                              );
                            } else {
                              String userImageUrl = snapshot.data!;
                              return CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(userImageUrl),
                                radius: 35,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Text(
                      '${vacancyData['first name']}',
                      style: GoogleFonts.raleway(
                          fontSize: 17.1, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${vacancyData['last name']}',
                      style: GoogleFonts.raleway(
                          fontSize: 17.1, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: screenWidth * 0.034,
                    ),
                    Align(
                      key: phonekey,
                      alignment: Alignment.centerRight,
                      child: phoneSection,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  key: threedkey,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThreeDViewPage(
                                email: '${vacancyData['email']}',
                                modelName: '${vacancyData['ID']}.obj')),
                      );
                    },
                    child: Container(
                      width: 90,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFDB2227),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('View 3D model',
                            style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Column(
                        key: pricekey,
                        children: [
                          Text(
                            'Price Range',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${vacancyData['Starting Price'] + ' OM'} - ${vacancyData['End Price'] + ' OM'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4EFB12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 70),
                      Padding(
                        key: inquirekey,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestForVacancy(
                                  baseID: vacancyData['baseID'],
                                  imagename: widget.imageName,
                                  token: vacancyData['token'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 90,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFDB2227),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text('RENT NOW',
                                  style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchData(
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

  Future<String> fetchUserImage(String email) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref('User_Profile_Picture/$email/profile');
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error retrieving user image: $e');
      return '';
    }
  }
}
