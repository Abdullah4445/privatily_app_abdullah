import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for semantic text and images

/// Premium Bonus section with SEO enhancements
class PremiumBonusSection extends StatefulWidget {
  const PremiumBonusSection({super.key});

  @override
  State<PremiumBonusSection> createState() => _PremiumBonusSectionState();
}

class _PremiumBonusSectionState extends State<PremiumBonusSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Side Text
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title as SEO-enhanced heading
                    Seo.text(
                      text: '${'bonus_title_prefix'.tr} ${'bonus_title_suffix'.tr}',
                      style: TextTagStyle.h2,
                      child: Text.rich(
                        TextSpan(
                          text: 'bonus_title_prefix'.tr,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'bonus_title_suffix'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Description as SEO-enhanced paragraph
                    Seo.text(
                      text: 'bonus_description'.tr,
                      style: TextTagStyle.p,
                      child: Text(
                        'bonus_description'.tr,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40, height: 40),
              // Right Side Image
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Seo.image(
                  src: 'assets/images/bonuses.png',
                  alt: 'Premium bonuses graphic',
                  child: Image.asset(
                    'assets/images/bonuses.png',
                    width: isMobile ? 300 : 500,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
