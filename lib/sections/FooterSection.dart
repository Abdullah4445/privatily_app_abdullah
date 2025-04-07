import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;

      return Container(
        color: const Color(0xFF3E29F0),
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
                      Image.asset('assets/images/logo_white.png', height: 40),
                      const SizedBox(height: 10),
                      const Text(
                        "Powering entrepreneurs up!",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      _contactRow(Icons.email, "Support@privatily.com"),
                      _contactRow(Icons.phone, "+1 (507) 410-4666"),
                      _contactRow(Icons.article, "Helpdesk articles"),
                      _contactRow(Icons.help_outline, "FAQ"),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
                          SizedBox(width: 16),
                          FaIcon(FontAwesomeIcons.twitter, color: Colors.white, size: 18),
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
                      _linkColumn("About us", [
                        "Contact us",
                        "Pricing",
                        "KYC & AML policy",
                        "Service accessibility"
                      ]),
                      _linkColumn("Privacy policy", [
                        "Refund policy",
                        "Terms and conditions",
                        "Legal disclaimer",
                        "Copyrights"
                      ]),
                    ],
                  ),
                ),

                // Person Image
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
            const Text(
              '© 2019–2025 All rights reserved.\n'
                  'Privatily is not a law firm nor can provide legal advice. We specialize in providing tech-based business services and insightful guidance for general understanding. '
                  'The information on our website, as well as that shared via emails, WhatsApp, Slack, SMS, Zoom, social media, and other communication platforms, is for informational purposes only and should not be taken as legal advice. '
                  'By using our services and accessing our website, you agree to our Terms of Service, Privacy Policy, and Data Processing Addendum.',
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
