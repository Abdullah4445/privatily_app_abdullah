import 'package:flutter/material.dart';

class WhyIncorporateUsSection extends StatelessWidget {
  const WhyIncorporateUsSection({super.key});

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
              text: 'Why Incorporate In ',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'The US',
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
                icon: Icons.workspace_premium_outlined,
                title: 'Trust',
                description:
                'Forming a company in the US is viewed as more trustworthy by financial service providers, like Stripe, PayPal and banks due to the nation’s established business infrastructure and stringent regulatory environment.',
              ),
              _FeatureCard(
                icon: Icons.security_outlined,
                title: 'Protection',
                description:
                'A US-based company provides a legal separation between a business and its owners, known as limited liability protection. This means that in the event of lawsuits or debts, personal assets of the owners are generally protected.',
              ),
              _FeatureCard(
                icon: Icons.military_tech_outlined,
                title: 'Prestige',
                description:
                'A US company can lend prestige and credibility to a business. The US is often seen as a leader in innovation and entrepreneurship, and having a US-based company can enhance the reputation of a business both domestically and internationally.',
              ),
            ],
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
