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
              'Last Updated: May 26, 2025\n\n'
                  'At LaunchCode.shop, all purchases are final and **non-refundable**. We encourage you to carefully review the script or product details before making a purchase.\n\n'
                  'Our products are digital in nature and delivered instantly upon successful payment. Due to the non-tangible, irrevocable nature of digital goods, we do not offer refunds under any circumstances.\n\n'
                  '**Important:**\n'
                  '- Make sure you fully understand the product.\n'
                  '- Only proceed with the payment if you are confident in your selection.\n\n'
                  'By completing a purchase on LaunchCode.shop, you acknowledge and agree to this no-refund policy.\n\n'
                  'If you have any questions before purchasing, feel free to contact us at: support@launchcode.shop',
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
