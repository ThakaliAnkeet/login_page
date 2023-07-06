import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationReceiver {
  static void configureNotificationHandling(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground notification: ${message.notification?.body}');
      // Handle the notification and show a dialog or take appropriate action
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Vacancy Request'),
          content: Text(message.notification?.body ?? ''),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle button press, navigate to appropriate screen, etc.
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling background notification: ${message.notification?.body}');
    // If needed, handle the notification here and perform appropriate actions
  }
}
