import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;

      return Container(
        color: const Color(0xFF1B5E20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Brand & Contact Info
                SizedBox(
                  width: isMobile ? double.infinity : 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'footer_tagline'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      _contactRow(Icons.email, 'support@launchcode.shop'),
                      _contactRow(Icons.phone, '+1 (507) 410-4666'),
                      _contactRow(Icons.article, 'footer_guides'.tr),
                      _contactRow(Icons.help_outline, 'footer_support'.tr),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
                          SizedBox(width: 16),
                          FaIcon(FontAwesomeIcons.twitter, color: Colors.white, size: 18),
                          SizedBox(width: 16),
                          FaIcon(FontAwesomeIcons.linkedinIn, color: Colors.white, size: 18),
                          SizedBox(width: 16),
                          FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),

                // Links Section
                SizedBox(
                  width: isMobile ? double.infinity : 400,
                  child: Wrap(
                    spacing: 50,
                    runSpacing: 20,
                    children: [
                      _linkColumn('footer_explore'.tr, [
                        'footer_home'.tr,
                        'footer_pricing'.tr,
                        'footer_faqs'.tr,
                        'footer_testimonials'.tr
                      ]),
                      _linkColumn('footer_legal'.tr, [
                        'footer_terms'.tr,
                        'footer_privacy'.tr,
                        'footer_refund'.tr,
                        'footer_license'.tr
                      ]),
                    ],
                  ),
                ),

                // Footer Image
                SizedBox(
                  width: isMobile ? double.infinity : 250,
                  child: Image.asset(
                    'assets/images/footer_person.png',
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(color: Colors.white30),
            const SizedBox(height: 10),

            // Disclaimer
            Text(
              'footer_disclaimer'.tr,
              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
            ),
          ],
        ),
      );
    });
  }

  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _linkColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(link, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        )),
      ],
    );
  }
}
