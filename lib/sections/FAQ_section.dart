import 'package:flutter/material.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _activeIndex;
  int? _hoveredIndex;

  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How long does it take to launch my apps?',
      'answer': [
        'Basic deployments take 5–7 business days.',
        'Premium packages are prioritized and completed within 2–3 business days.',
        'This includes launching to Play Store, App Store, and setting up hosting.',
      ]
    },
    {
      'question': 'What material do I need to provide?',
      'answer': [
        'Your business name and logo.',
        'App icons, splash screen (optional).',
        'Developer account access or invitation (Google, Apple, etc.).',
      ]
    },
    {
      'question': 'Can you publish apps on both Play Store and App Store?',
      'answer': [
        'Yes! LaunchCode supports publishing to both stores.',
        'We also configure your admin panel and host it using services like Hostinger or GoDaddy.',
      ]
    },
    {
      'question': 'Do I need coding experience to use LaunchCode?',
      'answer': [
        'Nope! We handle the technical setup and launch process for you.',
        'You just need to choose your script and provide the required content.',
      ]
    },
    {
      'question': 'What happens after the apps are live?',
      'answer': [
        'You’ll receive a handover package with credentials and links.',
        'From there, you can start promoting and earning revenue right away!',
      ]
    },
  ];

  void _toggleIndex(int index) {
    setState(() {
      _activeIndex = _activeIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F7FF),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate(faqItems.length, (index) {
            final item = faqItems[index];
            final isExpanded = _activeIndex == index;
            final isHovered = _hoveredIndex == index;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? Colors.white
                      : isHovered
                      ? const Color(0xFFF3F6FE)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (isHovered || isExpanded)
                      const BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => _toggleIndex(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                          isHovered ? const Color(0xFF00C853) : Colors.black87,
                        ),
                        child: Text(item['question']),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: const Color(0xFF00C853),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            item['answer'].length,
                                (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      item['answer'][i],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
