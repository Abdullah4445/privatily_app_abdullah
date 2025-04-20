import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Refund Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'At LaunchCode.shop, we value your satisfaction. If you are not satisfied with your purchase, you can request a refund within 2 days of purchasing the product. '
                  'Refund requests made after 2 days will not be accepted. Please follow the steps below to initiate your refund request:\n\n'
                  '1. Contact our support team at support@launchcode.com.\n'
                  '2. Provide your order details, including your order ID and purchase date.\n'
                  '3. Explain the reason for your refund request.\n\n'
                  'We will review your request and respond within 1 business day.\n\n'
                  'Please note that refunds are only eligible for products purchased directly through our platform. Digital goods and services are subject to our terms of service and may not be refunded after the 2-day window.\n\n'
                  'Thank you for choosing LaunchCode.shop, and we look forward to assisting you!',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
