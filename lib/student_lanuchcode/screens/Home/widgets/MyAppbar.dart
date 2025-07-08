import 'package:flutter/material.dart';

import '../../../widgets/appbar.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BAppbar(
      title: Text(
        "Student App.launch Code",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      profile: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset("assets/images/user.png"),
      ),
      actions: [Icon(Icons.logout, color: Colors.white)],
    );
  }
}