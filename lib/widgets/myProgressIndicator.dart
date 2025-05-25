import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoader extends StatelessWidget {
  const MyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        height: 90,
        width: 90,
        'assets/myGif.gif', // Replace with your Lottie file

      ),
    );
  }
}