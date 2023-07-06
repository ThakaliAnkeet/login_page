// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/LoginPages/Custlogin.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:login_page/admindashboard.dart';

class AddServiceEngineer extends StatefulWidget {
  @override
  State<AddServiceEngineer> createState() => _AddServiceEngineerState();
}

class _AddServiceEngineerState extends State<AddServiceEngineer> {
  // text controllers
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  String encryptedText = '';
  String errorMessage = '';
  bool _obscureText = true;
  File? file;
  var _currentItemSelected = "Electrical Services";
  var role = "Engineer";
  var Service = "Electrical Service";

  String encryptPassword(String _passwordController) {
    final bytes = utf8.encode(_passwordController);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String encryptConfirmPassword(String _confirmpasswordController) {
    final bytes = utf8.encode(_confirmpasswordController);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (_key.currentState!.validate()) {
      if (passwordConfirmed()) {
        //create User
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
          //add User Details
          addUserDetails(
            _firstnameController.text.trim(),
            _lastnameController.text.trim(),
            _emailController.text.trim(),
            int.parse(
              _ageController.text.trim(),
            ),
            encryptedText = encryptPassword(_passwordController.text.trim()),
            role = 'Engineer',
            Service = _currentItemSelected,
          );
          errorMessage = '';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } on FirebaseAuthException catch (error) {
          if (error.code == 'email-already-in-use') {
            errorMessage = 'This email is already registered.';
          } else {
            errorMessage = error.message!;
          }
        }
        setState(() {});
      }
    }
  }

  Future addUserDetails(String firstname, String lastname, String email,
      int age, String encryptedText, String role, String Service) async {
    await FirebaseFirestore.instance.collection('Customers').add({
      'first name': firstname,
      'last name': lastname,
      'age': age,
      'email': email,
      'password': encryptedText,
      'role': 'Engineer',
      'service': Service,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  Hello
                Text(
                  'Hello There',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 50),

                //  Email

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: validateEmail,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            border: InputBorder.none,
                            hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 5.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                  ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _firstnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a first name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: InputBorder.none,
                            hintText: 'First Name'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _lastnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: InputBorder.none,
                            hintText: 'Last Name'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _ageController,
                        validator: validateAge,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.timeline),
                            border: InputBorder.none,
                            hintText: 'Age'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //  Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: validatePass,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            hintText: 'Password'),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //  Confirm Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _confirmpasswordController,
                        validator: (value) => validateConfirmPass(
                            value, _passwordController.text),
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            hintText: 'Confirm Password'),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                //  Sign-in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                //  Register
              ],
            ),
          ),
        ),
      )),
    );
  }

  String? validateAge(String? formAge) {
    if (formAge == null || formAge.isEmpty) {
      return 'Age is required';
    }

    int? age = int.tryParse(formAge);
    if (age == null) {
      return 'Invalid age format';
    }

    if (age < 18 || age > 100) {
      return 'Age must be between 18 and 100';
    }

    return null;
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'Email address is required.';

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail format';

  return null;
}

String? validatePass(String? formPass) {
  if (formPass == null || formPass.isEmpty)
    return 'Password section is required';

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPass))
    return '''
    Password must include at least 8 characters,
    include an uppercase letter, number and symbol.
  ''';
  return null;
}

String? validateConfirmPass(String? formPass, String? password) {
  if (formPass == null || formPass.isEmpty)
    return 'Password section is required';

  if (password != formPass) {
    return 'Passwords do not match';
  }

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPass))
    return '''
    Password must include at least 8 characters,
    include an uppercase letter, number and symbol.
  ''';
  return null;
}
