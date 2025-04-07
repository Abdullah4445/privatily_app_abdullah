import 'package:flutter/material.dart';

class TestimonialSection extends StatefulWidget {
  const TestimonialSection({super.key});

  @override
  State<TestimonialSection> createState() => _TestimonialSectionState();
}

class _TestimonialSectionState extends State<TestimonialSection>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  final List<Map<String, String>> testimonials = [
    {
      'message':
      'Their speed and prices are unmatched! Starting my business in the U.S. with Privatily was very easy. Their team took care of everything, and I really can’t thank them enough.',
      'name': 'Yusuf',
      'country': 'From Pakistan 🇵🇰'
    },
    {
      'message':
      'Privatily provides excellent customer service. They are always responsive to concerns and keep you updated throughout the process. I was recommended to them by a friend and I highly recommend them to others.',
      'name': 'Chinedu',
      'country': 'From Nigeria 🇳🇬'
    },
    {
      'message':
      'I got an outstanding service for my US LLC formation. Their team was not only professional but also highly responsive throughout the entire process, making everything seamless and efficient.',
      'name': 'Jamal',
      'country': 'From Morocco 🇲🇦'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      testimonials.length,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _fadeAnimations = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: c, curve: Curves.easeIn),
    ))
        .toList();

    _slideAnimations = _controllers
        .map((c) => Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: c, curve: Curves.easeOut),
    ))
        .toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (var controller in _controllers) {
      await Future.delayed(const Duration(milliseconds: 300));
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Trusted by entrepreneurs\nfrom 150+ countries',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              // 🎯 Box-style gradient background
              Container(
                height: 280, // ✅ Adjusted height for perfect balance
                width: 980,  // ✅ Matches visual layout in screenshot
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF5C4DFF), // 💜 Deep Purple (Left)
                      Color(0xFFAA6EFF), // 💜 Light Purple (Center)
                      Color(0xFFFF9E9E), // ❤️ Pinkish Red (Right)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 60,
                      spreadRadius: 10,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
              ),


              // Testimonials with animation
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(testimonials.length, (index) {
                  final testimonial = testimonials[index];
                  return FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: _TestimonialCard(
                        message: testimonial['message']!,
                        name: testimonial['name']!,
                        country: testimonial['country']!,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String message;
  final String name;
  final String country;

  const _TestimonialCard({
    required this.message,
    required this.name,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            country,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
