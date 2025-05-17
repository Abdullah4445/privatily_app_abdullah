// Service Cards Widget – Freelance Services with WhatsApp Launcher & Lottie

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCards extends StatefulWidget {
  const ServiceCards({super.key});

  @override
  State<ServiceCards> createState() => _ServiceCardsState();
}

class _ServiceCardsState extends State<ServiceCards> {
  int _hoveredIndex = -1;

  final List<Map<String, dynamic>> services =[
    {
      'icon': Icons.movie_edit,
      'title': 'Video Editing'.tr,
      'subtitle': 'Professional reels, shorts, promos'.tr,
    },
    {
      'icon': Icons.code,
      'title': 'App, Web, Desktop & Arduino Development'.tr,
      'subtitle': 'Landing pages to full-stack apps'.tr,
    },

    {
      'icon': Icons.bar_chart,
      'title': 'SEO'.tr,
      'subtitle': 'Rank on Google organically'.tr,
    },
    {
      'icon': Icons.phone_android,
      'title': 'ASO'.tr,
      'subtitle': 'App Store Optimization services'.tr,
    },
    {
      'icon': Icons.campaign,
      'title': 'SMM'.tr,
      'subtitle': 'We manage social media growth'.tr,
    },
    {
      'icon': Icons.storefront,
      'title': 'E-commerce Setup'.tr,
      'subtitle': 'Launch Shopify/WooCommerce stores'.tr,
    },
    {
      'icon': Icons.brush,
      'title': 'Logo & Branding'.tr,
      'subtitle': 'Custom logos, brand kits, assets'.tr,
    },
    {
      'icon': Icons.edit_note,
      'title': 'Content Writing'.tr,
      'subtitle': 'SEO blogs, scripts, articles'.tr,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: services.length,
          itemBuilder: (context, index) {
            final step = services[index];
            final isHovered = _hoveredIndex == index;
            final whatsappUrl = "https://wa.me/923058431046?text=Hello, I am interested in your ${step['title']} service.";

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: AnimatedScale(
                scale: isHovered ? 1.05 : 1.0,
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
                  child: Stack(
                    children: [
                      Container(
                        width: 220,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(step['icon'], size: 30, color: Colors.blueAccent),
                            const SizedBox(height: 3),
                            Text(
                              step['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step['subtitle'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      // ✅ Lottie top right
                      Positioned(
                        top: 6,
                        right: 6,
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Lottie.asset(
                            'assets/lotties/idea.json',
                            repeat: true,
                            animate: true,
                          ),
                        ),
                      ),
                      // ✅ WhatsApp icon top left
                      Positioned(
                        top: 6,
                        left: 6,
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
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}