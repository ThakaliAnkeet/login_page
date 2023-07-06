import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    final String username = 'thakaliankeet@gmail.com';
    final String password = 'uhvqevmihqhpvqwr';

    final random = Random.secure();
    final passwordLength = 8;
    final characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';

    String generatedRandomPassword() {
      bool hasCapital = false;
      bool hasSpecial = false;
      bool hasNumber = false;
      String password = '';

      while (!hasCapital || !hasSpecial || !hasNumber) {
        password = '';
        hasCapital = false;
        hasSpecial = false;
        hasNumber = false;

        // Generate the password
        for (int i = 0; i < passwordLength; i++) {
          password += characters[random.nextInt(characters.length)];
        }

        // Check if the password meets the requirements
        for (var char in password.split('')) {
          if (char.contains(RegExp(r'[A-Z]'))) {
            hasCapital = true;
          } else if (char.contains(RegExp(r'[!@#\$%^&*()]'))) {
            hasSpecial = true;
          } else if (char.contains(RegExp(r'[0-9]'))) {
            hasNumber = true;
          }
        }
      }

      return password;
    }

    final generatedPassword = generatedRandomPassword();

    final SmtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(_emailController.text.trim())
      ..subject = 'Password Reset'
      ..text = 'Your new password is: $generatedPassword';

    setState(() {
      _isLoading = true;
    });
    try {
      final SendReport = await send(message, SmtpServer);
      print('Message sent:' + SendReport.toString());
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(generatedPassword);
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Reset Password sent! Check your email'),
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error occured while sending email:$e');
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Failed to send email'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFDB2227),
          title: Text('Reset Password'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Enter Your Email and we will send you a reset password',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFDB2227)),
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
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Email'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Stack(alignment: Alignment.center, children: [
              MaterialButton(
                onPressed: passwordReset,
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white),
                ),
                color: Color(0xFFDB2227),
              ),
              if (_isLoading) CircularProgressIndicator(),
            ])
          ],
        ));
  }
}
