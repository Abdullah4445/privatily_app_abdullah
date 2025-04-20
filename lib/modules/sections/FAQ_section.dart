import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _activeIndex;
  int? _hoveredIndex;

  final List<String> faqKeys = [
    'faq_q1',
    'faq_q2',
    'faq_q3',
    'faq_q4',
    'faq_q5',
  ];

  final List<List<String>> faqAnswers = [
    ['faq_q1_a1', 'faq_q1_a2', 'faq_q1_a3'],
    ['faq_q2_a1', 'faq_q2_a2', 'faq_q2_a3'],
    ['faq_q3_a1', 'faq_q3_a2'],
    ['faq_q4_a1', 'faq_q4_a2'],
    ['faq_q5_a1', 'faq_q5_a2'],
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
          Text(
            'faq_heading'.tr,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          ...List.generate(faqKeys.length, (index) {
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
                          color: isHovered
                              ? const Color(0xFF00C853)
                              : Colors.black87,
                        ),
                        child: Text(faqKeys[index].tr),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        color: const Color(0xFF00C853),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            faqAnswers[index].length,
                                (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text(
                                      faqAnswers[index][i].tr,
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
