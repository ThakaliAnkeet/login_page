import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../Homepages/ImageScrollview.dart';

class ViewVacantFlats extends StatefulWidget {
  const ViewVacantFlats({super.key});

  @override
  State<ViewVacantFlats> createState() => _ViewVacantFlatsState();
}

class _ViewVacantFlatsState extends State<ViewVacantFlats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancies'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Text('Available Vacancies'),
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Container(
                child: ImageScrollView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
