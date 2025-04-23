import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:seo/seo.dart'; // SEO package for image semantics

class PrivatilyPreviewImage extends StatefulWidget {
  const PrivatilyPreviewImage({super.key});

  @override
  State<PrivatilyPreviewImage> createState() => _PrivatilyPreviewImageState();
}

class _PrivatilyPreviewImageState extends State<PrivatilyPreviewImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('privatily-preview-image'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) {
          _startAnimation();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Seo.image(
                src: 'assets/images/pp.png',
                alt: 'Launchcode Preview Screenshot',
                child: Image.asset(
                  'assets/images/pp.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
