import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

class FixedPriceBanner extends StatefulWidget {
  int price;
  String text;
 FixedPriceBanner({super.key, required this.text,required this.price});

  @override
  State<FixedPriceBanner> createState() => _FixedPriceBannerState();
}
//
class _FixedPriceBannerState extends State<FixedPriceBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 40,
          // padding: const EdgeInsets.symmetric(horizontal: 18, vertical:18),
          padding: EdgeInsets.only(left: 12, right: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF007CF0), Color(0xFF00DFD8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            "🚀${widget.text}: \$${widget.price}",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}





class PlanCard extends StatefulWidget {
  final String text;
  final int price;
  final String supportDays;
  final String deliveryTime;

  const PlanCard({
    super.key,
    required this.text,
    required this.price,
    required this.supportDays,
    required this.deliveryTime,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final whatsappUrl = "https://wa.me/923058431046?text=Hello, I would like to go with ${widget.text}";

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: () async {
            final Uri uri = Uri.parse(whatsappUrl);
            if (!await launchUrl(uri)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch WhatsApp')),
              );
            }
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FixedPriceBanner(price: widget.price, text: widget.text),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.support_agent, size: 18, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text(
                            'support_with_days'.trParams({'days': widget.supportDays.toString()}),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'delivery_time_with_days'.trParams({'days': widget.deliveryTime.toString()}),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.price_check_outlined, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Fixed Price for all Scripts'.tr,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ WhatsApp Icon Top Right
                Positioned(
                  bottom: 5,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      final Uri uri = Uri.parse(whatsappUrl);
                      if (!await launchUrl(uri)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not launch WhatsApp')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // ✅ Lottie on hover — e.g. rocket flare
                if (_hovered)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Lottie.asset(
                        'assets/lotties/rocket.json', // 🔥 change to your lottie
                        repeat: true,
                        animate: true,
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

