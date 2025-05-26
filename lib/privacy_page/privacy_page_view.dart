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
              'Last Updated: May 26, 2025\n\n'
                  'This Privacy Policy outlines how LaunchCode collects, uses, and protects your personal information when you use our website and services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Information We Collect\n'
                  'We may collect personal details such as your name, email address, profile photo, and payment information. We also collect technical data like device information, browser type, IP address, and usage statistics.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. How We Use Your Information\n'
                  'We use your information to operate our services, manage your account, provide customer support, send updates, and improve user experience.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Sharing Your Data\n'
                  'We do not sell your personal information. We may share data with trusted partners to help provide and improve our services or as required by law.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '4. Data Security\n'
                  'We use industry-standard security practices to protect your personal information. However, no method of transmission over the internet is completely secure.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '5. Your Rights\n'
                  'You may access, update, or delete your personal data at any time. You may also withdraw your consent where applicable.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '6. Cookies and Tracking Technologies\n'
                  'We may use cookies and similar tools to enhance user experience and analyze site usage. You can control cookie settings through your browser.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '7. Changes to This Policy\n'
                  'We may revise this Privacy Policy periodically. Updated versions will be posted on our website with the new effective date.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '8. Contact Us\n'
                  'If you have any questions or concerns about this Privacy Policy, please contact us at: support@launchcode.shop',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
