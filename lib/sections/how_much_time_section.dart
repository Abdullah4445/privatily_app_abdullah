import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HowMuchTimeSection extends StatefulWidget {
  const HowMuchTimeSection({super.key});

  @override
  State<HowMuchTimeSection> createState() => _HowMuchTimeSectionState();
}

class _HowMuchTimeSectionState extends State<HowMuchTimeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

  Widget timeBox(int endValue, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
        children: [
          _visible
              ? TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: endValue),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, _) => Text(
              '${value}h',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          )
              : const Text(
            '0h',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget hourglassImage(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Image.asset(
        'assets/images/hourglass.png',
        width: isMobile ? 180 : 340,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return VisibilityDetector(
      key: const Key('llc-time-section'),
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
                colors: [Color(0xFF5238E6), Color(0xFF121B38)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How much time to get your LLC?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'At Privatily we count delivery time by business hours, not\n'
                            'by days or weeks like others do.\n'
                            'However, please be aware that these timelines are\n'
                            'applicable only if you opt for LLC registration in one of our\n'
                            'recommended US states.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      hourglassImage(isMobile),
                    ],
                  ),
                ),
                const SizedBox(width: 40, height: 40),
                // Right side
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        timeBox(24, 'LLC formation'),
                        timeBox(24, 'Company docs delivery'),
                        timeBox(120, 'EIN acquisition'),
                        timeBox(165, 'Avg. order delivery time'),
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
