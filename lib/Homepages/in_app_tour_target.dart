import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> CusthomeTargets({
  required GlobalKey menukey,
  required GlobalKey searchkey,
  required GlobalKey navigationkey,
  required GlobalKey scrollkey,
  required GlobalKey listkey,
}) {
  List<TargetFocus> targets = [];
  // search
  targets.add(
    TargetFocus(
      keyTarget: searchkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Search through the services and apartments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // menu
  targets.add(
    TargetFocus(
      keyTarget: menukey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the menu button, click this button to open menu sidebar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // profile

  // navigation
  targets.add(
    TargetFocus(
      keyTarget: navigationkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Choose what you need Apartments or services',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // scroll
  targets.add(
    TargetFocus(
      keyTarget: scrollkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Scroll thorugh the various choices and select the one that catches your eye',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // list
  targets.add(
    TargetFocus(
      keyTarget: listkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'See a list of the best choices available',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  return targets;
}

List<TargetFocus> CusthomesideTargets({
  required GlobalKey profilekey,
  required GlobalKey reportkey,
  required GlobalKey locationkey,
  required GlobalKey settingskey,
  required GlobalKey logoutkey,
}) {
  List<TargetFocus> custhometargets = [];
  custhometargets.add(
    TargetFocus(
      keyTarget: profilekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'View your user profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // report
  custhometargets.add(
    TargetFocus(
      keyTarget: reportkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Navigate to the report page where you can write a report about the service or apartment',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // location
  custhometargets.add(
    TargetFocus(
      keyTarget: locationkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'View your current locatin through google maps',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // settings
  custhometargets.add(
    TargetFocus(
      keyTarget: settingskey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'View application settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // logout
  custhometargets.add(
    TargetFocus(
      keyTarget: logoutkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Logout from the account',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  return custhometargets;
}

List<TargetFocus> vacancyDetailTargets({
  required GlobalKey imagekey,
  required GlobalKey desckey,
  required GlobalKey phonekey,
  required GlobalKey threedkey,
  required GlobalKey pricekey,
  required GlobalKey inquirekey,
}) {
  List<TargetFocus> vdtargets = [];
  // image
  vdtargets.add(
    TargetFocus(
      keyTarget: imagekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the image of the vacancy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // Description
  vdtargets.add(
    TargetFocus(
      keyTarget: desckey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the description of the vacancy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // phone
  vdtargets.add(
    TargetFocus(
      keyTarget: phonekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Click the phone icon to get the number of the renter and click the message icon to inquire the renter about the vacancy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // 3d model
  vdtargets.add(
    TargetFocus(
      keyTarget: threedkey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Click the button to view the 3D model of the vacancy if available',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // price
  vdtargets.add(
    TargetFocus(
      keyTarget: pricekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the price range set by the renter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // inquire button
  vdtargets.add(
    TargetFocus(
      keyTarget: inquirekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Press this button to inquire and send a mail to the renter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  return vdtargets;
}

List<TargetFocus> serviceDetailTargets({
  required GlobalKey imagekey,
  required GlobalKey desckey,
  required GlobalKey phonekey,
  required GlobalKey pricekey,
  required GlobalKey inquirekey,
}) {
  List<TargetFocus> sdtargets = [];
  // image
  sdtargets.add(
    TargetFocus(
      keyTarget: imagekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the image of the service',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // Description
  sdtargets.add(
    TargetFocus(
      keyTarget: desckey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the description of the service',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // phone
  sdtargets.add(
    TargetFocus(
      keyTarget: phonekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Click the phone icon to get the number of the engineer and click the message icon to inquire the engineer about the service',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // price
  sdtargets.add(
    TargetFocus(
      keyTarget: pricekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'This is the price range set by the engineer',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  // inquire button
  sdtargets.add(
    TargetFocus(
      keyTarget: inquirekey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Press this button to inquire and send a mail to the engineer',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  return sdtargets;
}
