import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransparentPricingSection extends StatefulWidget {
  const TransparentPricingSection({super.key});

  @override
  State<TransparentPricingSection> createState() => _TransparentPricingSectionState();
}

class _TransparentPricingSectionState extends State<TransparentPricingSection> {
  String selectedCountry = 'us';

  final Map<String, Map<String, dynamic>> pricingData = {
    'us': {
      'basic': {
        'price': '\$15',
        'description': 'basic_us_desc'.tr,
        'features': [
          'basic_us_feature1'.tr,
          'basic_us_feature2'.tr,
          'basic_us_feature3'.tr,
          'basic_us_feature4'.tr,
        ]
      },
      'premium': {
        'price': '\$60',
        'description': 'premium_us_desc'.tr,
        'features': [
          'premium_us_feature1'.tr,
          'premium_us_feature2'.tr,
          'premium_us_feature3'.tr,
          'premium_us_feature4'.tr,
          'premium_us_feature5'.tr,
        ]
      }
    },
    // Add 'uk', 'canada', and 'world' the same way with .tr
  };

  @override
  Widget build(BuildContext context) {
    final selected = pricingData[selectedCountry]!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              text: 'transparent'.tr,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'pricing'.tr,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('where_live'.tr),
          const SizedBox(height: 12),
          ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            isSelected: [
              selectedCountry == 'us',
              selectedCountry == 'uk',
              selectedCountry == 'canada',
              selectedCountry == 'world'
            ],
            onPressed: (index) => setState(() => selectedCountry = ['us', 'uk', 'canada', 'world'][index]),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('in_us'.tr),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('in_uk'.tr),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('in_canada'.tr),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('in_world'.tr),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildCard(selected['basic']!, isPremium: false),
              _buildCard(selected['premium']!, isPremium: true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data, {required bool isPremium}) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFF043927) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPremium ? 'premium'.tr : 'basic'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPremium ? Colors.white : Colors.black,
                ),
              ),
              if (isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'priority_support'.tr,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: data['price'],
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: isPremium ? Colors.white : Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'per_hour'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: isPremium ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data['description'],
            style: TextStyle(
              color: isPremium ? Colors.white70 : Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPremium ? Colors.green : Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () {},
            child: Text(isPremium ? 'go_premium'.tr : 'go_basic'.tr),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              data['features'].length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      index == 0 && isPremium ? Icons.double_arrow_rounded : Icons.check,
                      color: isPremium ? Colors.white : Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['features'][index],
                        style: TextStyle(
                          color: isPremium ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
