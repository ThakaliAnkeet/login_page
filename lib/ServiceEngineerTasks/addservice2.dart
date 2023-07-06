import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:login_page/ServiceEngineerTasks/addservice3.dart';

class Addservice2 extends StatefulWidget {
  const Addservice2({super.key});

  @override
  State<Addservice2> createState() => _Addservice2State();
}

class _Addservice2State extends State<Addservice2> {
  final _key = GlobalKey<FormState>();

  RangeValues _currentRangeValues = const RangeValues(40, 80);
  TextEditingController startsliderController = TextEditingController();
  TextEditingController endsliderController = TextEditingController();
  TextEditingController averageController = TextEditingController();
  TextEditingController scopeController = TextEditingController();
  String errorMessage = '';

  double _startSliderValue = 0;
  double _endSliderValue = 5000;
  late FocusNode startSliderFocusNode;
  late FocusNode endSliderFocusNode;
  String? _imageUrl;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startSliderValue = double.tryParse(startsliderController.text) ?? 0;
    _endSliderValue = double.tryParse(startsliderController.text) ?? 5000;

    startSliderFocusNode = FocusNode();
    endSliderFocusNode = FocusNode();
  }

  void handleCalculateAverage() {
    double average = calculateAverage();
    averageController.text = average.toStringAsFixed(2);
  }

  double calculateAverage() {
    double startPrice = double.tryParse(startsliderController.text) ?? 0;
    double endPrice = double.tryParse(endsliderController.text) ?? 0;

    return (startPrice + endPrice) / 2;
  }

  void updateSlidersFromTextFields() {
    setState(() {
      _startSliderValue = double.tryParse(startsliderController.text) ?? 0;
      _endSliderValue = double.tryParse(endsliderController.text) ?? 5000;
    });
  }

  Future<void> _selectImage() async {
    var user_email = FirebaseAuth.instance.currentUser!.email;

    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = 'ServiceImage';
      final storagePath = 'Service_Image/$user_email/$fileName';

      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final task = storageRef.putFile(file);
      await task.whenComplete(() async {
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      }).catchError((error) {
        print('Image upload Error:$error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Configuration'),
        backgroundColor: Color(0xFFDB2227),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pricing And Scope',
                  style: GoogleFonts.bebasNeue(fontSize: 40),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Price Range",
                    style: GoogleFonts.bebasNeue(fontSize: 20),
                  ),
                ),
                Text('Start Price'),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    controller: startsliderController,
                    validator: validatePrice,
                    onChanged: (value) {
                      updateSlidersFromTextFields();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter(
                        RegExp(r'^([0-9]{0,4})$'),
                        allow: true,
                        replacementString: '',
                      ),
                    ],
                  ),
                ),
                Container(child: StatefulBuilder(builder: (context, state) {
                  return Slider.adaptive(
                      value: _startSliderValue,
                      min: 0,
                      max: 5000,
                      divisions: 5000,
                      label: _startSliderValue.round().toString(),
                      onChanged: (double value) {
                        state(() {
                          _startSliderValue = value;
                          startsliderController.text =
                              _startSliderValue.toString();
                        });
                      });
                })),
                Text('End Price'),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    controller: endsliderController,
                    validator: validatePrice,
                    onChanged: (value) {
                      updateSlidersFromTextFields();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter(
                        RegExp(r'^([0-9]{0,4})$'),
                        allow: true,
                        replacementString: '',
                      ),
                    ],
                  ),
                ),
                Container(child: StatefulBuilder(builder: (context, state) {
                  return Slider.adaptive(
                      value: _endSliderValue,
                      min: 0,
                      max: 5000,
                      divisions: 5000,
                      label: _endSliderValue.round().toString(),
                      onChanged: (double value) {
                        state(() {
                          _endSliderValue = value;
                          endsliderController.text = _endSliderValue.toString();
                        });
                      });
                })),
                Text(
                  "Average Price:",
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: averageController,
                    validator: validatePrice,
                  ),
                ),
                ElevatedButton(
                  onPressed: handleCalculateAverage,
                  child: Text('Calculate Average'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDB2227)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Scope'),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 150,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Add a description about your service',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 80.0),
                      ),
                      controller: scopeController,
                      validator: validateScope,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _imageUrl != null
                    ? Image.network(
                        _imageUrl!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(),

                SizedBox(height: 16),

                // Button to upload an image
                ElevatedButton(
                  onPressed: () => _selectImage(),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFDB2227),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('Upload Image')),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDB2227)),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: GestureDetector(
                    onTap: update,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFDB2227),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Next',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validatePrice(String? value) {
    if (value!.isEmpty) {
      return 'Enter a price';
    }
  }

  Future update() async {
    if (_key.currentState!.validate()) {
      try {
        addServiceDetails(
            startsliderController.text.trim(),
            endsliderController.text.trim(),
            averageController.text.trim(),
            scopeController.text.trim());
        errorMessage = '';
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddService3()));
      } on FirebaseException catch (error) {
        errorMessage = error.message!;
      }
      setState(() {});
    }
  }

  Future addServiceDetails(String Start_price, String end_price,
      String average_price, String Scope) async {
    var user_email = FirebaseAuth.instance.currentUser!.email;
    await FirebaseFirestore.instance
        .collection('Engineer_Services')
        .doc(user_email)
        .update({
      'Starting Price': Start_price,
      'End Price': end_price,
      "Average Price": average_price,
      'Scope': Scope
    });
  }

  String? validateScope(String? value) {
    if (value!.isEmpty) {
      return 'Enter your Service Description';
    }
  }
}
