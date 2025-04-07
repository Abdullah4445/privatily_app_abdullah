import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'widgets/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      title: 'Privatily App',
    );
  }
}
