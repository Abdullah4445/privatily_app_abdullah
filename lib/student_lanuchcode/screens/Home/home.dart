import 'package:flutter/material.dart';
import 'package:privatily_app/student_lanuchcode/screens/Home/widgets/Hometextfield.dart';
import 'package:privatily_app/student_lanuchcode/screens/Home/widgets/MyAppbar.dart';
import 'package:privatily_app/student_lanuchcode/screens/Home/widgets/responsiveoptionwidget.dart';



import '../../widgets/primaryheadercontainer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // purple header container
            BPrimaryHeaderContainer(
              child: Container(
                width: double.infinity,
                color: Colors.deepPurple,
                child: Column(
                  children: [
                    // Appbar of home page
                    MyAppbar(),

                    HomeTextField(),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            ResponsiveOptionsWidget()

          ],
        ),
      ),
    );
  }
}
