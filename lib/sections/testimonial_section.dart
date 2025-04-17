import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      'message': 'testimonial_msg_1'.tr,
      'name': 'testimonial_name_1'.tr,
      'country': 'testimonial_country_1'.tr,
    },
    {
      'message': 'testimonial_msg_2'.tr,
      'name': 'testimonial_name_2'.tr,
      'country': 'testimonial_country_2'.tr,
    },
    {
      'message': 'testimonial_msg_3'.tr,
      'name': 'testimonial_name_3'.tr,
      'country': 'testimonial_country_3'.tr,
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
          Text(
            'testimonial_heading'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
              Container(
                height: 280,
                width: 980,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF00B36B),
                      Color(0xFF00D084),
                      Color(0xFF32CD32),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 60,
                      spreadRadius: 10,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
              ),
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
