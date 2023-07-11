// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/forgotpassword.dart';
import 'package:login_page/profilepage.dart';

import 'Admin Tasks/Apartmentspage.dart';
import 'Admin Tasks/Flatinformation.dart';
import 'Admin Tasks/ServiceEngineersPage.dart';
import 'Admin Tasks/Servicespage.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          backgroundColor: Color(0xFFDB2227),
        ),
        drawer: Drawer(
          backgroundColor: Color(0xFFDB2227),
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFDB2227),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.white),
                title: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () => _signOut(context),
              ),
            ],
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              ListTile(
                title: Text('Add Service Engineers'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddServiceEngineer()),
                  );
                },
              ),
              ListTile(
                title: Text('Apartments'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApartmentsPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Services'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServicesPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Flat Information'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlatInformationPage()),
                  );
                },
              ),
            ],
          ),
        ));
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/asignup');
  }
}
