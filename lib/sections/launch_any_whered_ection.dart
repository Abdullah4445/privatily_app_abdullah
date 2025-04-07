import 'package:flutter/material.dart';

class LaunchAnywhereSection extends StatelessWidget {
  const LaunchAnywhereSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
      final isDesktop = constraints.maxWidth >= 1024;

      return Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 60,
          horizontal: isMobile ? 16 : 40,
        ),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Left Side Text
            Expanded(
              flex: isMobile ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(
                  right: isMobile ? 0 : 40,
                  bottom: isMobile ? 30 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Launch your company\nfrom ',
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        children: const [
                          TextSpan(
                            text: '→ anywhere',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Act now! Gain exclusive access to top-tier financial solutions, reserved solely for US-based companies, and significantly boost your business’s potential for success.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: isMobile ? 13 : 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (!isMobile) const SizedBox(width: 40),

            // ✅ Right Side Image
            Expanded(
              flex: isMobile ? 0 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/img.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
