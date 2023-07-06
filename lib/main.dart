import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_page/Admin%20Tasks/ServiceEngineersPage.dart';
import 'package:login_page/Homepages/Custhome.dart';
import 'package:login_page/Homepages/ServiceEngineerhome.dart';
import 'package:login_page/Homepages/Tenanthome.dart';
import 'package:login_page/LoginPages/Custlogin.dart';
import 'package:login_page/LoginPages/resetpassword.dart';
import 'package:login_page/admindashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/asignup': (context) => CustLogin(),
        '/csignup': (context) => CustLogin(),
        '/esignup': (context) => CustLogin(),
        '/tsignup': (context) => CustLogin(),
        '/service-engineer-home': (context) => Serviceenghome(),
        '/customer-home': (context) => CustHome(),
        '/tenant-home': (context) => TenantHome(),
        '/admin-home': (context) => AdminDashboard(),
      },
      debugShowCheckedModeBanner: false,
      home: CustLogin(),
    );
  }
}
