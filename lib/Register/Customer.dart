// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:login_page/LoginPages/Custlogin.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:login_page/LoginPages/roleselectionpage.dart';

class CustomerRegister extends StatefulWidget {
  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  // text controllers
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  String encryptedText = '';
  String errorMessage = '';
  bool _obscureText = true;
  File? file;
  String role = '';
  String civilId = '';

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
    _contactController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (_key.currentState!.validate()) {
      if (passwordConfirmed()) {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Send email verification
          await userCredential.user!.sendEmailVerification();

          // Add User Details
          addUserDetails(
            _firstnameController.text.trim(),
            _lastnameController.text.trim(),
            _emailController.text.trim(),
            int.parse(_ageController.text.trim()),
            int.parse(_contactController.text.trim()),
            encryptedText = encryptPassword(_passwordController.text.trim()),
            role = '',
            civilId = '',
            false, // User verification status is set to false initially
          );

          errorMessage = '';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email Verification'),
                content: Text(
                  'An email verification link has been sent to your email address. Please verify your email before signing in.',
                ),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoleSelection()),
                      );
                    },
                  ),
                ],
              );
            },
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

  Future addUserDetails(
    String firstname,
    String lastname,
    String email,
    int age,
    int contact,
    String encryptedText,
    String role,
    String civilId,
    bool isVerified, // Add parameter for verification status
  ) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('Customers').doc(userId).set({
      'first name': firstname,
      'last name': lastname,
      'age': age,
      'contact': contact,
      'email': email,
      'password': encryptedText,
      'role': role,
      'civilId': civilId,
      'isVerified': isVerified, // Store verification status
      'firstlogin': true
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
                      child: IntlPhoneField(
                        controller: _contactController,
                        validator: validatecontact,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
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
                          color: Color(0xFFDB2227),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustLogin()));
                      },
                      child: Text(
                        ' Sign In ',
                        style: TextStyle(
                          color: Color(0xFFDB2227),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
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

  FutureOr<String?> validatecontact(PhoneNumber? formcontact) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Customers')
              .where('contact', isEqualTo: _contactController)
              .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {}
      if (querySnapshot == _contactController) {
        print("The given contact number already exists");
      }
    } catch (e) {
      print(e);
    }
  }
}
