import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privatily_app/sections/featuredProducts/productController.dart';

class FeaturedProductsSection extends StatefulWidget {
  const FeaturedProductsSection({super.key});

  @override
  State<FeaturedProductsSection> createState() => _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    const scrollDuration = Duration(seconds: 2);
    const pauseDuration = Duration(milliseconds: 200);

    _autoScrollTimer = Timer.periodic(pauseDuration + scrollDuration, (_) async {
      if (!_scrollController.hasClients || _isUserScrolling) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      final target = (current + 300).clamp(0.0, maxScroll);

      await _scrollController.animateTo(
        target,
        duration: scrollDuration,
        curve: Curves.easeInOut,
      );

      // if we've reached the end, jump back to start
      if (target >= maxScroll) {
        await Future.delayed(const Duration(milliseconds: 200)); // little pause
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onUserScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      setState(() {
        _isUserScrolling = true;
      });
    } else if (notification is ScrollEndNotification) {
      setState(() {
        _isUserScrolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Obx(() {
      final products = controller.products;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Featured Products",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 420, // matches your card height
              child: ScrollConfiguration(
                behavior: _NoGlowScrollBehavior(), // Use the simplified behavior
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    _onUserScroll(notification);
                    return false;
                  },
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: products.length,
                    padding: const EdgeInsets.only(right: 16),
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        width: isMobile ? screenWidth * 0.8 : 590,
                        child: _buildCard(context, product),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCard(BuildContext context, product) {
    return Container(
      height: 430,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              product.thumbnailUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (c, e, st) => Container(
                height: 300,
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child:
                const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.attach_money,
                        size: 16, color: Colors.black54),
                    Text("${product.regularPrice}"),
                    const SizedBox(width: 12),
                    const Icon(Icons.star_border,
                        size: 16, color: Colors.black54),
                    Text("${product.soldCount} Sold"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}

// A ScrollBehavior that removes the glow effect.  You can customize this further if needed.
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}