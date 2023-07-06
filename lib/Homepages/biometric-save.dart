import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricSetupPage extends StatefulWidget {
  @override
  _BiometricSetupPageState createState() => _BiometricSetupPageState();
}

class _BiometricSetupPageState extends State<BiometricSetupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _passwordController = TextEditingController();

  bool _isFingerprintSaved = false;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Setup'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Text(
                'Set up biometrics for secure login:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: ElevatedButton(
                onPressed: _saveBiometrics,
                child: Text('Save Biometrics'),
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Account Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 30,
              ),
              child: ElevatedButton(
                onPressed: _verifyPassword,
                child: Text('Verify Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final isBiometricSupported = await _checkBiometricSupport();
      if (isBiometricSupported) {
        final isFingerprintVerified = await _authenticateWithBiometrics();
        if (!isFingerprintVerified) {
          setState(() {
            _errorMessage =
                'Fingerprint verification failed. Please try again.';
            _isLoading = false;
          });
          return;
        }
      } else {
        setState(() {
          _errorMessage =
              'Biometric authentication is not available on this device.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isFingerprintSaved = true;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error saving biometrics. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkBiometricSupport() async {
    final localAuth = LocalAuthentication();
    return await localAuth.canCheckBiometrics;
  }

  Future<bool> _authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();

    try {
      return await localAuth.authenticate(
        localizedReason: 'Please authenticate to save your biometrics.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Fingerprint authentication error: ${e.message}');
      return false;
    }
  }

  void _verifyPassword() async {
    final String password = _passwordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your account password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );
        await currentUser.reauthenticateWithCredential(credential);

        if (_isFingerprintSaved) {
          await _firestore
              .collection('Customers')
              .doc(currentUser.uid)
              .update({'biometricsSaved': true});
        } else {
          setState(() {
            _errorMessage =
                'Fingerprint not saved. Please save biometrics first.';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _isLoading = false;
        });

        // Redirect to settings page after successful biometrics setup
        Navigator.pop(context);
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Incorrect password. Please try again.';
        _isLoading = false;
      });
    }
  }
}
