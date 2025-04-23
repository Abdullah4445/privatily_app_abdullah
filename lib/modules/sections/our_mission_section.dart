import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for semantic text and images

class OurMissionSection extends StatelessWidget {
  const OurMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isMobile)
                Column(
                  children: [
                    _imagePart(),
                    const Gap(30),
                    _textPart(),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: _imagePart()),
                    const Gap(60),
                    Expanded(flex: 1, child: _textPart()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePart() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Seo.image(
          src: 'assets/images/girl_mission_image.png',
          alt: 'Illustration of our mission – empowering developers',
          child: Image.asset(
            'assets/images/girl_mission_image.png',
            width: 420,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _textPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Seo.text(
          text: '${'mission_heading_1'.tr} ${'mission_heading_2'.tr}',
          style: TextTagStyle.h2,
          child: RichText(
            text: TextSpan(
              text: 'mission_heading_1'.tr,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: ' mission_heading_2'.tr,
                  style: const TextStyle(color: Color(0xFF00C853)),
                ),
              ],
            ),
          ),
        ),
        const Gap(20),
        Seo.text(
          text: 'mission_description'.tr,
          style: TextTagStyle.p,
          child: Text(
            'mission_description'.tr,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
