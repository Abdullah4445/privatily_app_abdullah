import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoader extends StatelessWidget {
  const MyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/myGif.gif', // Replace with your Lottie file

      ),
    );
  }
}