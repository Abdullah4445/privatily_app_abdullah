import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
                )
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
        child: Image.asset(
          'assets/images/girl_mission_image.png',
          width: 420,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _textPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Our Mission at ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: 'Privatily',
                style: TextStyle(
                  color: Color(0xFF5C4DFF),
                ),
              )
            ],
          ),
        ),
        const Gap(20),
        const Text(
          "Privatily’s mission is to be the global partner for aspiring business\n"
              "owners, streamlining the path to company formation in the USA,\n"
              "UK, and Canada. We deliver a comprehensive suite of services,\n"
              "from LLC and LTD registrations to full business incorporation,\n"
              "designed for modern entrepreneurial needs. Our goal is to\n"
              "empower clients to quickly and confidently establish and grow\n"
              "their businesses worldwide.",
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
