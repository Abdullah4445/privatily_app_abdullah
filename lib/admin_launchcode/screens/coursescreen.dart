import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'addnew/addform.dart';

class CourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.to(CourseFormScreen());

            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: Text(
              "Add new course",
              // No need for TextStyle here if foregroundColor in styleFrom is set
            ),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Center(child: Text('Manage your course here')),
    );
  }
}
