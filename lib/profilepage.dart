import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  String? _errorMessage; // Declare as nullable

  bool _isSubmitting = false;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPasswordVisible = !_currentPasswordVisible;
                      });
                    },
                    child: Icon(_currentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                obscureText: !_currentPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _currentPassword = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                    child: Icon(
                      _newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !_newPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  } else if (!_isPasswordValid(value)) {
                    return '''
                      Password must include at least 8 characters,
                      include an uppercase letter, number, and symbol.
                    ''';
                  } else if (value == _currentPassword) {
                    return 'New password should be different from the current password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _newPassword = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _confirmNewPasswordVisible =
                            !_confirmNewPasswordVisible;
                      });
                    },
                    child: Icon(
                      _confirmNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !_confirmNewPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  } else if (value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmNewPassword = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              if (_errorMessage != null) // Check for null value
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16.0),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDB2227)),
                      onPressed: _submit,
                      child: Text('Change Password'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isPasswordValid(String password) {
    RegExp regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=]).{8,}$',
    );
    return regex.hasMatch(password);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
        _isSubmitting = true;
      });

      try {
        User user = FirebaseAuth.instance.currentUser!;
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPassword);
        // Password updated successfully, you can provide feedback to the user

        setState(() {
          _isSubmitting = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password updated successfully.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString();
        });
      }
    }
  }
}
