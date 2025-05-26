import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'terms_and_conditions_logic.dart';

import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last Updated: May 26, 2025\n\n'
                  'Welcome to LaunchCode. By accessing or using our website, you agree to comply with and be bound by the following terms and conditions. If you do not agree to these terms, please refrain from using our services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Use of the Website\n'
                  'You agree to use our website only for lawful purposes and in a manner that does not infringe the rights of, restrict, or inhibit anyone else\'s use and enjoyment of the website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Intellectual Property\n'
                  'All content on this website, including text, graphics, logos, and images, is the property of LaunchCode or its content suppliers and is protected by international copyright laws.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. User Accounts\n'
                  'To access certain features, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '4. Product Information\n'
                  'We strive to ensure all product descriptions and prices are accurate. However, errors may occur and we reserve the right to correct them at any time.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '5. Orders and Payments\n'
                  'All orders are subject to acceptance and availability. Payments must be made through the methods specified on the website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '6. Shipping and Delivery\n'
                  'Delivery times are estimates and not guaranteed. We are not responsible for delays caused by carriers or external factors.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '7. Returns and Refunds\n'
                  'Please refer to our Return Policy. We reserve the right to refuse returns that do not comply with our policy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '8. Limitation of Liability\n'
                  'To the fullest extent permitted by law, LaunchCode shall not be liable for any damages arising from the use or inability to use this website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '9. Indemnification\n'
                  'You agree to indemnify and hold harmless LaunchCode and its affiliates from any claims or liabilities arising from your use of the website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '10. Changes to Terms\n'
                  'We reserve the right to modify these terms at any time. Changes are effective upon posting. Continued use implies acceptance.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '11. Governing Law\n'
                  'These terms are governed by the laws of Pakistan and disputes shall be subject to its exclusive jurisdiction.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '12. Contact Information\n'
                  'For questions regarding these Terms and Conditions, contact us at: support@launchcode.shop',
              style: TextStyle(fontSize: 16),
            ),
          ],
        )

      ),
    );
  }
}
