import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    final horizontalSpacing = isMobile ? 24.0 : 80.0;

    return VisibilityDetector(
      key: const Key('home-stats-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() {
            _visible = true;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: horizontalSpacing,
            runSpacing: 20,
            children: [
              _StatItem(title: 'Clients', endValue: 2300, animate: _visible),
              _StatItem(title: 'Companies formed', endValue: 2800, animate: _visible),
              _StatItem(title: 'Countries served', endValue: 150, animate: _visible),
              _StatItem(title: 'Years of experience', endValue: 6, animate: _visible),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final String title;
  final int endValue;
  final bool animate;

  const _StatItem({
    required this.title,
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = IntTween(begin: 0, end: widget.endValue).animate(_controller)
      ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant _StatItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start animation when 'animate' becomes true
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
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_animation.value}+',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
