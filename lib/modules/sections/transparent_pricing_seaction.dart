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
        'price': 'us_basic_price',
        'description': 'us_basic_description',
        'features': [
          'us_basic_feature1',
          'us_basic_feature2',
          'us_basic_feature3',
          'us_basic_feature4',
        ],
      },
      'premium': {
        'price': 'us_premium_price',
        'description': 'us_premium_description',
        'features': [
          'us_premium_feature1',
          'us_premium_feature2',
          'us_premium_feature3',
          'us_premium_feature4',
          'us_premium_feature5',
        ],
      },
    },
    'uk': {
      'basic': {
        'price': 'uk_basic_price',
        'description': 'uk_basic_description',
        'features': [
          'uk_basic_feature1',
          'uk_basic_feature2',
          'uk_basic_feature3',
          'uk_basic_feature4',
        ],
      },
      'premium': {
        'price': 'uk_premium_price',
        'description': 'uk_premium_description',
        'features': [
          'uk_premium_feature1',
          'uk_premium_feature2',
          'uk_premium_feature3',
          'uk_premium_feature4',
          'uk_premium_feature5',
        ],
      },
    },
    'canada': {
      'basic': {
        'price': 'canada_basic_price',
        'description': 'canada_basic_description',
        'features': [
          'canada_basic_feature1',
          'canada_basic_feature2',
          'canada_basic_feature3',
          'canada_basic_feature4',
        ],
      },
      'premium': {
        'price': 'canada_premium_price',
        'description': 'canada_premium_description',
        'features': [
          'canada_premium_feature1',
          'canada_premium_feature2',
          'canada_premium_feature3',
          'canada_premium_feature4',
          'canada_premium_feature5',
        ],
      },
    },
    'world': {
      'basic': {
        'price': 'world_basic_price',
        'description': 'world_basic_description',
        'features': [
          'world_basic_feature1',
          'world_basic_feature2',
          'world_basic_feature3',
          'world_basic_feature4',
        ],
      },
      'premium': {
        'price': 'world_premium_price',
        'description': 'world_premium_description',
        'features': [
          'world_premium_feature1',
          'world_premium_feature2',
          'world_premium_feature3',
          'world_premium_feature4',
          'world_premium_feature5',
        ],
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    print("selectedCountry $selectedCountry");
    final selected = pricingData[selectedCountry];
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
              _buildCard(selected!['basic']!, isPremium: false),
              _buildCard(selected!['premium']!, isPremium: true),
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
              text: '${data['price']}'.tr,
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
            '${data['description']}'.tr,
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
                        '${data['features'][index]}'.tr,
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
