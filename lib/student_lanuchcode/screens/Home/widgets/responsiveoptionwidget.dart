import 'package:flutter/material.dart';
import '../../../constant/list.dart';
 // your list of CustomOptionContainer widgets

class ResponsiveOptionsWidget extends StatelessWidget {
  const ResponsiveOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // allow parent to scroll
        itemCount: optionWidgets.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180, // 👈 This defines the max width of each item
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1, // Keep the aspect ratio of your containers
        ),
        itemBuilder: (context, index) {
          return optionWidgets[index]; // your fixed-size widgets
        },
      ),
    );
  }
}
