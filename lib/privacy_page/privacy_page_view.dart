import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'privacy_page_logic.dart';

import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last Updated: April 2025\n\n'
                  'This Privacy Policy explains how LaunchCode collects, uses, and protects your personal data when you use our mobile application and services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Data Collection\n'
                  'We collect personal information, such as your name, email address, and profile photo, when you register for an account. We may also collect information about your usage of the App, including device information, location data, and usage statistics.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Data Usage\n'
                  'We use your data to provide and improve the App, including user authentication, service delivery, and personalized experiences.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Data Sharing\n'
                  'We do not share your personal data with third parties except as necessary to provide our services, comply with the law, or protect our rights.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '4. Data Security\n'
                  'We implement reasonable security measures to protect your personal data. However, we cannot guarantee the absolute security of data transmitted over the internet.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '5. User Rights\n'
                  'You have the right to access, correct, or delete your personal data. You may also withdraw consent for data processing at any time.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '6. Changes to Privacy Policy\n'
                  'We may update this Privacy Policy from time to time. Any changes will be communicated within the App or on our website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '7. Contact Information\n'
                  'If you have any questions or concerns about our Privacy Policy, please contact us at: contact@launchcode.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
