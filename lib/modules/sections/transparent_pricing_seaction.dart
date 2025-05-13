import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for semantic text

/// Transparent Pricing section with full region data and SEO semantics
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
          'us_basic_feature1'.tr,
          'us_basic_feature2'.tr,
          'us_basic_feature3'.tr,
          'us_basic_feature4'.tr,
        ],
      },
      'premium': {
        'price': 'us_premium_price',
        'description': 'us_premium_description',
        'features': [
          'us_premium_feature1'.tr,
          'us_premium_feature2'.tr,
          'us_premium_feature3'.tr,
          'us_premium_feature4'.tr,
          'us_premium_feature5'.tr,
        ],
      },
    },
    'uk': {
      'basic': {
        'price': 'uk_basic_price',
        'description': 'uk_basic_description',
        'features': [
          'uk_basic_feature1'.tr,
          'uk_basic_feature2'.tr,
          'uk_basic_feature3'.tr,
          'uk_basic_feature4'.tr,
        ],
      },
      'premium': {
        'price': 'uk_premium_price',
        'description': 'uk_premium_description',
        'features': [
          'uk_premium_feature1'.tr,
          'uk_premium_feature2'.tr,
          'uk_premium_feature3'.tr,
          'uk_premium_feature4'.tr,
          'uk_premium_feature5'.tr,
        ],
      },
    },
    'canada': {
      'basic': {
        'price': 'canada_basic_price',
        'description': 'canada_basic_description',
        'features': [
          'canada_basic_feature1'.tr,
          'canada_basic_feature2'.tr,
          'canada_basic_feature3'.tr,
          'canada_basic_feature4'.tr,
        ],
      },
      'premium': {
        'price': 'canada_premium_price',
        'description': 'canada_premium_description',
        'features': [
          'canada_premium_feature1'.tr,
          'canada_premium_feature2'.tr,
          'canada_premium_feature3'.tr,
          'canada_premium_feature4'.tr,
          'canada_premium_feature5'.tr,
        ],
      },
    },
    'world': {
      'basic': {
        'price': 'world_basic_price',
        'description': 'world_basic_description',
        'features': [
          'world_basic_feature1'.tr,
          'world_basic_feature2'.tr,
          'world_basic_feature3'.tr,
          'world_basic_feature4'.tr,
        ],
      },
      'premium': {
        'price': 'world_premium_price',
        'description': 'world_premium_description',
        'features': [
          'world_premium_feature1'.tr,
          'world_premium_feature2'.tr,
          'world_premium_feature3'.tr,
          'world_premium_feature4'.tr,
          'world_premium_feature5'.tr,
        ],
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    final selected = pricingData[selectedCountry]!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section title as SEO-enhanced h2
          Seo.text(
            text: '${'transparent'.tr} ${'pricing'.tr}',
            style: TextTagStyle.h2,
            child: Text.rich(
              TextSpan(
                text: 'transparent'.tr,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: ' ${'pricing'.tr}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Country toggle label as SEO-enhanced p
          Seo.text(
            text: 'where_live'.tr,
            style: TextTagStyle.p,
            child: Text('where_live'.tr),
          ),
          const SizedBox(height: 12),
          ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            isSelected: [
              selectedCountry == 'us',
              selectedCountry == 'uk',
              selectedCountry == 'canada',
              selectedCountry == 'world',
            ],
            onPressed: (index) => setState(
                  () => selectedCountry = ['us', 'uk', 'canada', 'world'][index],
            ),
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
              _PricingCard(data: selected['basic']!, isPremium: false),
              _PricingCard(data: selected['premium']!, isPremium: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isPremium;

  const _PricingCard({required this.data, required this.isPremium, super.key});

  @override
  Widget build(BuildContext context) {
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
          // Plan name as SEO-enhanced h3
          Seo.text(
            text: isPremium ? 'premium'.tr : 'basic'.tr,
            style: TextTagStyle.h3,
            child: Text(
              isPremium ? 'premium'.tr : 'basic'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPremium ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Price as SEO-enhanced h2
          Seo.text(
            text: '${data['price']}'.tr,
            style: TextTagStyle.h2,
            child: RichText(
              text: TextSpan(
                text: '${data['price']}'.tr,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isPremium ? Colors.white : Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' per_hour'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPremium ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Description as SEO-enhanced paragraph
          Seo.text(
            text: '${data['description']}'.tr,
            style: TextTagStyle.p,
            child: Text(
              '${data['description']}'.tr,
              style: TextStyle(
                color: isPremium ? Colors.white70 : Colors.black54,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // CTA button as SEO link
          Seo.link(
            href: '#',
            anchor: isPremium ? 'go_premium'.tr : 'go_basic'.tr,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium ? Colors.green : Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: () {},
              child: Text(isPremium ? 'go_premium'.tr : 'go_basic'.tr),
            ),
          ),
          const SizedBox(height: 20),
          // Features list as SEO-enhanced list items
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              (data['features'] as List).length,
                  (index) {
                final featureKey = data['features'][index];
                return Seo.text(
                  text: featureKey,
                  style: TextTagStyle.h1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          index == 0 && isPremium
                              ? Icons.double_arrow_rounded
                              : Icons.check,
                          color: isPremium ? Colors.white : Colors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            featureKey,
                            style: TextStyle(
                              color: isPremium ? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
