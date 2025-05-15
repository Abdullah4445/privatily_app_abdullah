import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seo/seo.dart'; // SEO package for semantic text and images

/// "Why LaunchCode" section with SEO enhancements
class WhyLaunchCodeSection extends StatefulWidget {
  const WhyLaunchCodeSection({super.key});

  @override
  State<WhyLaunchCodeSection> createState() => _WhyLaunchCodeSectionState();
}

class _WhyLaunchCodeSectionState extends State<WhyLaunchCodeSection>
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

  Widget featureItem(IconData icon, String textKey) {
    return _HoverableFeatureItem(icon: icon, textKey: textKey);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Textual content column
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section heading as SEO-enhanced h2
                    Seo.text(
                      text: 'why_launchcode_heading'.tr,
                      style: TextTagStyle.h2,
                      child: Text(
                        'why_launchcode_heading'.tr,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Section subtext as SEO-enhanced paragraph
                    Seo.text(
                      text: 'why_launchcode_subtext'.tr,
                      style: TextTagStyle.p,
                      child: Text(
                        'why_launchcode_subtext'.tr,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Feature list
                    featureItem(Icons.extension, 'feature_prebuilt'),
                    featureItem(Icons.flash_on_outlined, 'feature_quicklaunch'),
                    featureItem(Icons.support_agent_outlined, 'feature_support'),
                  ],
                ),
              ),
              const SizedBox(width: 40, height: 40),
              // Illustrative image column
              Expanded(
                flex: isMobile ? 0 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Seo.image(
                    src: 'assets/images/whyLaunch.png',
                    alt: 'Why choose LaunchCode illustration',
                    child: Image.asset(
                      'assets/images/whyLaunch.png',
                      fit: BoxFit.contain,
                    ),
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

class _HoverableFeatureItem extends StatefulWidget {
  final IconData icon;
  final String textKey;

  const _HoverableFeatureItem({
    required this.icon,
    required this.textKey,
  });

  @override
  State<_HoverableFeatureItem> createState() => _HoverableFeatureItemState();
}

class _HoverableFeatureItemState extends State<_HoverableFeatureItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = isHovered ? Colors.deepPurple : Colors.blue;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFF0F3FF),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.icon,
                  key: ValueKey<bool>(isHovered),
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Feature text as SEO-enhanced list item (paragraph)
            Seo.text(
              text: widget.textKey.tr,
              style: TextTagStyle.p,
              child: Flexible(
                child: Text(
                  widget.textKey.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}