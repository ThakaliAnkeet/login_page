import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Future<void> _navigateToGoogleMaps() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        final latitude = position.latitude;
        final longitude = position.longitude;

        final mapUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

        if (await canLaunch(mapUrl)) {
          await launch(mapUrl);
        } else {
          throw 'Could not launch Google Maps.';
        }
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Error'),
          content: Text('Failed to retrieve location.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _navigateToGoogleMaps,
          child: Text('Open Google Maps'),
        ),
      ),
    );
  }
}
