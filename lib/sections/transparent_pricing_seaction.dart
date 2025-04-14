import 'package:flutter/material.dart';

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
        'price': '\$229',
        'yearly': '99\$/yr',
        'description': 'If you’re operating with a low budget.',
        'features': [
          'US Company Formation',
          'US Address with Mail forwarding',
          'Registered agent service',
          'US business Stripe account consultation',
          'EIN letter',
          'Incorporation documents',
          'Introduction to a professional accountant',
          'Email support only'
        ]
      },
      'premium': {
        'price': '\$397',
        'yearly': '99\$/yr',
        'description': 'Enhanced, fast, and premium service.',
        'features': [
          'Everything in Basic, plus:',
          'Order priority',
          'FREE Tax consultation',
          'Chat and phone support',
          'FREE US Phone number',
          'Dedicated account manager',
          'FREE Business website',
          'FREE business email inbox',
          'FREE .com domain',
          'Business bank consultation',
          '3 Business logos',
          'Exclusive LaunchCode Bonuses'
        ]
      }
    },
    'uk': {
      'basic': {
        'price': '\$197',
        'yearly': '59\$/yr',
        'description': 'If you’re operating with a low budget.',
        'features': [
          'Your private company in the UK',
          'Registered office address',
          'UK Business Stripe account consultation',
          'Certificate of Incorporation',
          'Company documents',
          'Email support only'
        ]
      },
      'premium': {
        'price': '\$297',
        'yearly': '59\$/yr',
        'description': 'Enhanced, fast, and exclusive service.',
        'features': [
          'Everything in Basic, plus:',
          'Order priority',
          'Chat and phone support',
          'FREE UK Phone number',
          'Dedicated account manager',
          'FREE Business website',
          'FREE business email inbox',
          'FREE .com domain',
          'Business bank consultation',
          '3 Business logos',
          'Exclusive LaunchCode Bonuses'
        ]
      }
    },
    'canada': {
      'basic': {
        'price': '\$247',
        'yearly': '99\$/yr',
        'description': 'If you’re operating with a low budget.',
        'features': [
          'Registration as a Sole Proprietorship',
          'Business address',
          'Business Stripe account consultation',
          'Certificate of Incorporation',
          'Company documents',
          'Email support only'
        ]
      },
      'premium': {
        'price': '\$557',
        'yearly': '99\$/yr',
        'description': 'Enhanced, fast, and exclusive service.',
        'features': [
          'Everything in Basic, plus:',
          'Order priority',
          'Registration as a Corporation',
          'Chat and phone support',
          'Canadian phone number',
          'Dedicated account manager',
          'FREE Business website',
          'Bank account consultation',
          'FREE business email inbox',
          'FREE .com domain',
          '3 Business logos',
          'Exclusive LaunchCode Bonuses'
        ]
      }
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
          const Text.rich(
            TextSpan(
              text: 'Transparent ',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              children: [TextSpan(text: 'Pricing', style: TextStyle(color: Colors.green))],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Where do you want to Incorporate?'),
          const SizedBox(height: 12),
          ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            isSelected: [selectedCountry == 'us', selectedCountry == 'uk', selectedCountry == 'canada'],
            onPressed: (index) => setState(() => selectedCountry = ['us', 'uk', 'canada'][index]),
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In the US 🇺🇸')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In the UK 🇬🇧')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In Canada 🇨🇦')),
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
                isPremium ? 'Premium' : 'Basic',
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
                  child: const Text(
                    'Priority Processing',
                    style: TextStyle(fontSize: 11, color: Colors.white),
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
                  text: ' and then ${data['yearly']}',
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
            child: Text(isPremium ? 'Go Premium' : 'Go Basic'),
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
