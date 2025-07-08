import 'package:flutter/material.dart';

class CustomOptionContainer extends StatelessWidget {
  const CustomOptionContainer({
    super.key, required this.imagePath, required this.title,
  });
final String imagePath;
final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,

      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(title, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}