import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/Homepages/in_app_tour_target.dart';
import 'package:login_page/Renter/requestforservice.dart';
import 'package:login_page/Renter/requestforvacancy.dart';
import 'package:readmore/readmore.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cube/flutter_cube.dart';

class ServiceImageDetailView extends StatefulWidget {
  ServiceImageDetailView(
      {Key? key, required this.imageUrl, required this.imageName})
      : super(key: key);

  final String imageUrl;
  final String imageName;

  @override
  State<ServiceImageDetailView> createState() => _ServiceImageDetailViewState();
}

class _ServiceImageDetailViewState extends State<ServiceImageDetailView> {
  final imagekey = GlobalKey();
  final desckey = GlobalKey();
  final phonekey = GlobalKey();
  final pricekey = GlobalKey();
  final inquirekey = GlobalKey();

  late TutorialCoachMark _tutorialCoachMark;

  void _initServiceDetailtargets() {
    _tutorialCoachMark = TutorialCoachMark(
        targets: serviceDetailTargets(
            imagekey: imagekey,
            desckey: desckey,
            phonekey: phonekey,
            pricekey: pricekey,
            inquirekey: inquirekey),
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
      _tutorialCoachMark.show(context: context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initServiceDetailtargets();
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
        future: fetchData('Engineer_Services', widget.imageName),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> vacancyData =
                snapshot.data as Map<String, dynamic>;
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
                            builder: (context) => RequestForService(
                                  baseID: vacancyData['baseID'],
                                  imagename: widget.imageName,
                                )));
                  },
                  icon: msgsvg,
                  iconSize: 50,
                )
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        key: imagekey,
                        height: screenHeight * 0.33,
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
                                      offset: Offset(0, 3))
                                ],
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
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
                        '${vacancyData['Service Category']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 16,
                      child: Text(
                        '${vacancyData['Service Sub-Category']}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                Padding(
                  key: desckey,
                  padding: const EdgeInsets.all(8.0),
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
                      color: Color.fromARGB(255, 90, 89, 89),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
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
                      width: screenWidth * 0.07,
                    ),
                    Align(
                      key: phonekey,
                      alignment: Alignment.centerRight,
                      child: phoneSection,
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
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
                      SizedBox(
                        width: screenWidth * 0.15,
                      ),
                      Padding(
                        key: inquirekey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 8),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestForService(
                                    baseID: vacancyData['baseID'],
                                    imagename: widget.imageName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'INQUIRE NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDB2227),
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
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
