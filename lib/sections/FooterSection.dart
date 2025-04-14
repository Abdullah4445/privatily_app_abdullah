import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;

      return Container(
        color: const Color(0xFF1B5E20), // LaunchCode dark green
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // 🔰 Brand & Contact Info
                SizedBox(
                  width: isMobile ? double.infinity : 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/transperantLaunchCode.png', height: 40),
                      const SizedBox(height: 10),
                      const Text(
                        "Empowering startups and developers globally.",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      _contactRow(Icons.email, "support@launchcode.shop"),
                      _contactRow(Icons.phone, "+1 (507) 410-4666"),
                      _contactRow(Icons.article, "Launch guides & docs"),
                      _contactRow(Icons.help_outline, "Live Chat & Support"),
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

                // 🔗 Links Section
                SizedBox(
                  width: isMobile ? double.infinity : 400,
                  child: Wrap(
                    spacing: 50,
                    runSpacing: 20,
                    children: [
                      _linkColumn("Explore", [
                        "Home",
                        "Pricing",
                        "FAQs",
                        "Testimonials"
                      ]),
                      _linkColumn("Legal", [
                        "Terms of Service",
                        "Privacy Policy",
                        "Refund Policy",
                        "Licensing Info"
                      ]),
                    ],
                  ),
                ),

                // 👨‍💻 Footer Person Image
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

            // ⚖️ Disclaimer
            const Text(
              '© 2024–2025 LaunchCode. All rights reserved.\n'
                  'LaunchCode is a platform offering digital products & deployment services. We do not provide legal advice or act as a legal entity.\n'
                  'Use of our platform signifies agreement with our Terms, Privacy Policy, and Refund Policy. Please consult a legal or tax advisor where necessary.',
              style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
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
