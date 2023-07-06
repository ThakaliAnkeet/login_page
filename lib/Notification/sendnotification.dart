import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification({
  required String sendertoken,
  required String? receivertoken,
  required userbaseID,
  required baseID,
  required FirstName,
  required LastName,
}) async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  final userToken = await messaging.getToken();
  if (kDebugMode) {
    print('Registration Token=$userToken');
  }

  if (userToken != null) {
    final notificationMessage = {
      'notification': {
        'title': 'Vacancy Request',
        'body':
            'A vacancy request was sent by. Please contact as soon a possible.',
      },
      'token': userToken,
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAVzx7Iok:APA91bH7M4b5t3Zmo2wpy0_Z-hMb8Wb4aNXvWRG87u4AHofrR1q85oAoBNrXwGZkBYnat7TlwF2T98K2J3sFY5UeKkAcjkM_H6vXM7lKpLZgFhTNOantbuodXGZJx9auEbRUTHjQtsZL',
      },
      body: jsonEncode(notificationMessage),
    );

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) {
      throw new Exception("Error while fetching data");
    } else {
      print('Failed to send notification');
      print(response.statusCode);
    }
  } else {
    print('no token available');
  }
}
