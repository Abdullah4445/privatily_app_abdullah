import 'package:flutter/material.dart';

class WhyLaunchCodeSection2 extends StatelessWidget {
  const WhyLaunchCodeSection2({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 2,
          colors: [
            Color(0xFFF2F7FF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Why Choose ',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'LaunchCode',
                  style: TextStyle(
                    color: Color(0xFF5B3DF4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 30,
            children: const [
              _FeatureCard(
                icon: Icons.apps_outlined,
                title: 'Select Your Script',
                description:
                'Choose from our collection of high-converting software scripts designed for success in various industries.',
              ),
              _FeatureCard(
                icon: Icons.palette_outlined,
                title: 'Provide Customization Details',
                description:
                'Provide us with your business name, logo, design preferences, and any other required details to tailor the product to your needs.',
              ),
              _FeatureCard(
                icon: Icons.launch_outlined,
                title: 'Get Ready to Launch',
                description:
                'We’ll customize and deploy your app to the App Store, Play Store, and Admin Panel in as little as 3 days.',
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'With over 10 years in the industry and having served 2300+ clients, LaunchCode is the trusted partner for entrepreneurs worldwide. Our expert team ensures that your digital product is built, deployed, and live in no time!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.06),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                size: 30,
                color: _hovered ? Colors.deepPurple : Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


