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
        'price': '\$15/hour',
        'description': 'Basic support during business hours (9:00 AM to 5:00 PM EST).',
        'features': [
          '5 Days Support (9:00 AM to 5:00 PM EST)',
          'Standard script deployment',
          'Email support during business hours',
          'Basic cloud configuration'
        ]
      },
      'premium': {
        'price': '\$60/hour',
        'description': 'Priority support 24/7 with enhanced response times.',
        'features': [
          '24/7 Priority Support (All day, every day)',
          'Expedited script deployment',
          'Phone, chat, and email support anytime',
          'Advanced cloud configuration and optimization',
          'Faster deployment to app platforms with dedicated assistance'
        ]
      }
    },
    'uk': {
      'basic': {
        'price': '£12/hour',
        'description': 'Affordable support during standard business hours (9:00 AM to 5:00 PM GMT).',
        'features': [
          '5 Days Support (9:00 AM to 5:00 PM GMT)',
          'Standard script deployment',
          'Email support during business hours',
          'Basic web hosting setup'
        ]
      },
      'premium': {
        'price': '£50/hour',
        'description': 'Comprehensive 24/7 support with priority handling.',
        'features': [
          '24/7 Comprehensive Support (All day, every day)',
          'Priority script deployment and integration',
          'Phone, chat, and email support around the clock',
          'Advanced web hosting and domain management',
          'Accelerated deployment to app stores with expert guidance'
        ]
      }
    },
    'canada': {
      'basic': {
        'price': 'C\$18/hour',
        'description': 'Reliable support during standard business hours (9:00 AM to 5:00 PM EST).',
        'features': [
          '5 Days Support (9:00 AM to 5:00 PM EST)',
          'Standard application deployment',
          'Email support during business hours',
          'Basic server setup'
        ]
      },
      'premium': {
        'price': 'C\$65/hour',
        'description': 'Dedicated 24/7 support with rapid response and resolution.',
        'features': [
          '24/7 Dedicated Support (All day, every day)',
          'Priority application deployment and configuration',
          'Phone, chat, and email support at any time',
          'Premium server configuration and maintenance',
          'Quicker deployment to app marketplaces with expert assistance'
        ]
      }
    },
    'world': {
      'basic': {
        'price': '\$13/hour',
        'description': 'Global basic support during standard business hours (aligned with your timezone).',
        'features': [
          '5 Days Support (aligned with your timezone, 9:00 AM to 5:00 PM)',
          'Standard script and application deployment',
          'Email support during your business hours',
          'Basic hosting and domain guidance'
        ]
      },
      'premium': {
        'price': '\$55/hour',
        'description': 'Worldwide priority support 24/7 for critical issues.',
        'features': [
          '24/7 Global Priority Support (All day, every day)',
          'Expedited script and application deployment',
          'Phone, chat, and email support anytime, anywhere',
          'Premium hosting and domain management globally',
          'Faster deployment to global app stores with specialized support'
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
          const Text('Where do you live?'),
          const SizedBox(height: 12),
          ToggleButtons(
            borderRadius: BorderRadius.circular(20),
            isSelected: [selectedCountry == 'us', selectedCountry == 'uk', selectedCountry == 'canada',selectedCountry == 'world'],
            onPressed: (index) => setState(() => selectedCountry = ['us', 'uk', 'canada','world'][index]),
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In the US 🇺🇸')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In the UK 🇬🇧')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In Canada 🇨🇦')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('In World 🌎')),
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
                    'Priority Support',
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
                  text: ' per hour',
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
