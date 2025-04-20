import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

class HomeStatsSection extends StatefulWidget {
  const HomeStatsSection({super.key});

  @override
  State<HomeStatsSection> createState() => _HomeStatsSectionState();
}

class _HomeStatsSectionState extends State<HomeStatsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalSpacing = isMobile ? 20.0 : 60.0;

    return VisibilityDetector(
      key: const Key('home-stats-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
        color: const Color(0xFFF9F9FF),
        child: Column(
          children: [
            Text(
              'stats_title'.tr,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: horizontalSpacing,
                runSpacing: 30,
                children: [
                  _StatItem(titleKey: 'stats_clients', endValue: 2300, animate: _visible),
                  _StatItem(titleKey: 'stats_projects', endValue: 2800, animate: _visible),
                  _StatItem(titleKey: 'stats_countries', endValue: 150, animate: _visible),
                  _StatItem(titleKey: 'stats_years', endValue: 6, animate: _visible),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final String titleKey;
  final int endValue;
  final bool animate;

  const _StatItem({
    required this.titleKey,
    required this.endValue,
    required this.animate,
  });

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = IntTween(begin: 0, end: widget.endValue).animate(_controller)
      ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant _StatItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating && _animation.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${_animation.value}+',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.titleKey.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
