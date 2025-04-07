import 'package:flutter/material.dart';

class WhyPrivatilySection extends StatefulWidget {
  const WhyPrivatilySection({super.key});

  @override
  State<WhyPrivatilySection> createState() => _WhyPrivatilySectionState();
}

class _WhyPrivatilySectionState extends State<WhyPrivatilySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget featureItem(IconData icon, String text) {
    return _HoverableFeatureItem(icon: icon, text: text);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Privatily?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "We know how to take the complexity out of forming your company because we’ve been in your shoes. Privatily was born because we struggled ourselves—facing a complicated, lengthy process when trying to set up our own company in a supported country. Since 2019, we’ve been committed to providing unmatched expertise, affordable prices, and the fastest turnaround time to help entrepreneurs like you start your business journey smoothly and confidently.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    featureItem(Icons.workspace_premium_outlined, 'Expert guidance since 2019'),
                    featureItem(Icons.attach_money_outlined, 'Affordable, no hidden fees'),
                    featureItem(Icons.flash_on_outlined, 'Fast, hassle-free setup'),
                  ],
                ),
              ),
              const SizedBox(width: 40, height: 40),
              Expanded(
                flex: isMobile ? 0 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/why-privatily.png', // 👈 Replace with your actual image path
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

class _HoverableFeatureItem extends StatefulWidget {
  final IconData icon;
  final String text;

  const _HoverableFeatureItem({
    required this.icon,
    required this.text,
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
            Flexible(
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
