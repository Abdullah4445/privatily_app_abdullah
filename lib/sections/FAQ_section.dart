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
      'question': 'How much time you are going to take to finish my order?',
      'answer': [
        'Premium orders have a processing speed 3 times faster than Basic orders.',
        'We typically form companies within just 2 days.',
        'Securing the EIN takes an additional 3–5 days (Note: Most other providers require at least 2 weeks for EIN acquisition).',
      ]
    },
    {
      'question': 'What documents do I need to provide?',
      'answer': [
        'You only need a valid passport or national ID card and proof of address.',
        'Some additional forms may be required depending on your country.',
      ]
    },
    {
      'question': 'What about taxes?',
      'answer': [
        'We help you get started but we recommend consulting a US tax professional.',
        'Our Premium plan includes a tax consultation.',
      ]
    },
    {
      'question': 'Do you support my country?',
      'answer': [
        'Yes! We support entrepreneurs from over 150+ countries.',
        'You can check your eligibility on our website or contact us for help.',
      ]
    },
    {
      'question': "Your question wasn't listed above?",
      'answer': [
        'No worries. Our support team is available to help.',
        'Click on the live chat or email us your question anytime.',
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
            'Frequently asked questions',
            style: TextStyle(
              fontSize: 26,
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
                          color: isHovered ? Colors.deepPurple : Colors.black87,
                        ),
                        child: Text(item['question']),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: Colors.deepPurple,
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'For the US:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...item['answer'].map<Widget>((line) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      line,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
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
