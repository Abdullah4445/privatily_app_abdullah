import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for semantic text and images

/// "How Much Time" section with SEO enhancements
class HowMuchTimeSection extends StatefulWidget {
  const HowMuchTimeSection({super.key});

  @override
  State<HowMuchTimeSection> createState() => _HowMuchTimeSectionState();
}

class _HowMuchTimeSectionState extends State<HowMuchTimeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
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

  Widget _buildTimeBox(int endValue, String labelKey) {
    return Column(
      children: [
        // Animated value as SEO-enhanced heading
        Seo.text(
          text: '${endValue}d',
          style: TextTagStyle.h3,
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: _visible ? endValue : 0),
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, _) => Text(
              '${value}d',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Label as SEO-enhanced paragraph
        Seo.text(
          text: labelKey.tr,
          style: TextTagStyle.p,
          child: Text(
            labelKey.tr,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourglassImage(bool isMobile) {
    return Seo.image(
      src: 'assets/images/hourglass.png',
      alt: 'Hourglass illustrating development time',
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Image.asset(
          'assets/images/hourglass.png',
          width: isMobile ? 180 : 340,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return VisibilityDetector(
      key: const Key('launchcode-time-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() => _visible = true);
          _controller.forward();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF38E652), Color(0xFF1B3812)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title as SEO-enhanced heading
                      Seo.text(
                        text: 'how_time_title'.tr,
                        style: TextTagStyle.h2,
                        child: Text(
                          'how_time_title'.tr,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Description as SEO-enhanced paragraph
                      Seo.text(
                        text: 'how_time_description'.tr,
                        style: TextTagStyle.p,
                        child: Text(
                          'how_time_description'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      _buildHourglassImage(isMobile),
                    ],
                  ),
                ),
                const SizedBox(width: 40, height: 40),
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTimeBox(15, 'time_basic'),
                        _buildTimeBox(5, 'time_premium'),
                        _buildTimeBox(2, 'time_appstore'),
                        _buildTimeBox(1, 'time_playstore'),
                        _buildTimeBox(1, 'time_adminpanel'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
