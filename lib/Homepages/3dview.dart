import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class ThreeDViewPage extends StatefulWidget {
  final String email;
  final String modelName;

  const ThreeDViewPage({required this.email, required this.modelName});

  @override
  _ThreeDViewPageState createState() => _ThreeDViewPageState();
}

class _ThreeDViewPageState extends State<ThreeDViewPage> {
  String? modelFilePath;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchModelFile();
  }

  void fetchModelFile() async {
    try {
      String filePath = 'Vacancy_Files/${widget.email}/${widget.modelName}';
      print('storageref: $filePath');

      Reference storageReference = FirebaseStorage.instance.ref(filePath);
      String downloadURL = await storageReference.getDownloadURL();

      if (downloadURL.isEmpty) {
        setState(() {
          error = 'Model file not found';
        });
        return;
      }

      String localFilePath = await _downloadFile(downloadURL);
      print('filepath: $localFilePath');

      setState(() {
        modelFilePath = localFilePath;
      });
    } catch (e) {
      if (e is FirebaseException) {
        setState(() {
          error = 'No 3d model found for the corresponding vacancy';
        });
      } else {
        setState(() {
          error = 'Error retrieving model file: $e';
        });
      }
    }
  }

  Future<String> _downloadFile(String downloadURL) async {
    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String modelFilePath = '$appDocPath/${widget.modelName}';

    await dio.download(downloadURL, modelFilePath);

    return modelFilePath;
  }

  Future<String> _saveModelFile(List<int> bytes) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String modelFilePath = '$appDocPath/${widget.modelName}';

    File file = File(modelFilePath);
    await file.writeAsBytes(bytes);

    return modelFilePath;
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('3D View'),
          backgroundColor: Color(0xFFDB2227),
        ),
        body: Center(
          child: Text(
            error!,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (modelFilePath == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('3D View'),
          backgroundColor: Color(0xFFDB2227),
        ),
        body: Center(
          child: SpinKitFadingCube(
            color: Color(0xFFDB2227),
            size: 50.0,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('3D View'),
      ),
      body: Cube(
        onSceneCreated: (Scene scene) {
          scene.world.add(Object(
            fileName: modelFilePath!,
            isAsset: false,
          ));
          scene.camera.zoom = 10;
        },
      ),
    );
  }
}
