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
              'Last Updated: April 2025\n\n'
                  'By using LaunchCode, you agree to the following terms and conditions. If you do not agree to these terms, please refrain from using the app.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Introduction\n'
                  'These Terms and Conditions govern your use of the LaunchCode mobile application ("App") and the services provided within the App. By accessing and using the App, you agree to comply with these Terms and Conditions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '2. User Account\n'
                  'To use certain features of the App, you will need to create a user account. You are responsible for maintaining the confidentiality of your account credentials.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Subscription\n'
                  'Certain services within the App require a subscription. Details of the available subscription plans, including payment terms, will be displayed at the point of purchase.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '4. Privacy\n'
                  'Your privacy is important to us. Please review our Privacy Policy, which explains how we collect and use your personal information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '5. Termination\n'
                  'We may suspend or terminate your access to the App at any time for violations of these Terms or any applicable laws.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '6. Limitation of Liability\n'
                  'We are not liable for any damages arising from your use of the App, to the maximum extent permitted by law.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '7. Changes\n'
                  'We reserve the right to modify these Terms at any time. Any changes will be posted within the App or on our website.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '8. Contact Information\n'
                  'If you have any questions regarding these Terms, please contact us at: contact@launchcode.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
