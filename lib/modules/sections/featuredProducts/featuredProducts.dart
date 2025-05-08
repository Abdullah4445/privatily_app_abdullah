import 'dart:async';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seo/seo.dart'; // SEO package

import '../../../models/products.dart';
import '../../../widgets/myProgressIndicator.dart';
import '../../cart/cart_logic.dart';
import '../../cart/cart_view.dart';
import 'productController.dart';

/// Featured products carousel section with SEO enhancements
class FeaturedProductsSection extends StatefulWidget {
  const FeaturedProductsSection({super.key});

  @override
  State<FeaturedProductsSection> createState() => _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  final cartController = Get.put(CartLogic());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isLaptop = screenWidth >= 768 && screenWidth < 1600;
    final isDesktop = screenWidth >= 1600;

    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const CircularProgressIndicator(),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section title wrapped in SEO text
            Seo.text(
              text: 'Featured Products'.tr,
              style: TextTagStyle.h2,
              child: Text(
                'Featured Products'.tr,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Gap(5),
            SizedBox(
              width: double.infinity,
              height: isMobile ? 300 : 450,
              child: CarouselSlider.builder(
                itemCount: products.length,
                itemBuilder: (context, index, realIdx) {
                  final product = products[index];
                  return _buildCard(context, product);
                },
                options: CarouselOptions(
                  height: isMobile ? 300 : 450,
                  viewportFraction: isMobile
                      ? 0.85
                      : isLaptop
                      ? 0.38
                      : 0.26,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  initialPage: 0,
                  pageSnapping: true,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      Get.snackbar('Error', 'Could not launch URL');
    }
  }

  Widget _buildRatingStars(double rating) {
    final stars = <Widget>[];
    final full = rating.floor();
    final remainder = rating - full;
    for (var i = 0; i < full; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    if (remainder >= 0.25 && remainder < 0.75) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    } else if (remainder >= 0.75) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Widget _buildCard(BuildContext context, Project product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Seo.link(
      href: '/product-detail/${product.projectId}',
      anchor: product.title ?? 'Product',
      child: InkWell(
        onTap: () {
          if (product.projectId?.isNotEmpty != true) {
            Get.snackbar('Error', 'Missing product ID');
            return;
          }
          Get.toNamed(
            '/product-detail/${product.projectId}',
            arguments: product,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image wrapped in SEO image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Seo.image(
                  src: product.thumbnailUrl ?? '',
                  alt: product.title ?? 'Product image',
                  child: Image.network(
                    product.thumbnailUrl ?? 'https://via.placeholder.com/300x200?text=No+Image',
                    height: isMobile ? 215 : 295,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    loadingBuilder: (ctx, child, progress) {
                      return progress == null ? child : const MyLoader();
                    },
                    errorBuilder: (ctx, _, __) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product title and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Seo.text(
                            text: product.title ?? 'No Title',
                            style: TextTagStyle.h3,
                            child: Text(
                              product.title ?? 'No Title',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        _buildRatingStars(4.5),
                      ],
                    ),
                    const Gap(4),
                    // Product subtitle
                    Seo.text(
                      text: product.subtitle ?? '',
                      style: TextTagStyle.p,
                      child: Text(
                        product.subtitle ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(4),
                    // Price and sales count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Seo.text(
                          text: '\$${product.price?.toStringAsFixed(0) ?? 'N/A'}',
                          style: TextTagStyle.h4,
                          child: Text(
                            '\$${product.price?.toStringAsFixed(0) ?? 'N/A'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Seo.text(
                          text: '${product.soldCount ?? 0} Sales',
                          style: TextTagStyle.p,
                          child: Text(
                            '${product.soldCount ?? 0} Sales',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    // Add to cart button
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          cartController.add(product);
                          Get.snackbar(
                            'Added',
                            '${product.title} added to cart',
                            snackPosition: SnackPosition.BOTTOM,
                            mainButton: TextButton(
                              onPressed: () => Get.toNamed(CartPage.routeName),
                              child: const Text('VIEW CART'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}