import 'dart:async';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

// import 'package:gap/gap.dart'; // Gap package was imported but not used, can be removed if not needed elsewhere
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Adjust these import paths according to your project structure
import '../../../models/products.dart'; // Assuming Project model is here
import '../../cart/cart_logic.dart';
import '../../cart/cart_view.dart'; // Assuming CartPage is here
import '../../project_details/project_details_view.dart'; // Assuming ProjectDetailsPage is here
import 'productController.dart'; // Assuming ProductsController is here

class FeaturedProductsSection extends StatefulWidget {
  const FeaturedProductsSection({super.key});

  @override
  State<FeaturedProductsSection> createState() => _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  // Removed _scrollController, _autoScrollTimer, _isUserScrolling, _startAutoScroll, _onUserScroll
  // as they were not used with CarouselSlider.builder and caused confusion.
  // CarouselSlider handles its own scrolling and autoplay.

  // Keep CartLogic instance if needed within this widget (e.g., for add to cart)
  // Consider if it should be found globally instead: final cartController = Get.find<CartLogic>();
  final cartController = Get.put(CartLogic());

  // ProductsController should typically be found, not put here,
  // assuming it's initialized higher up (e.g., in main or Bindings)
  // final controller = Get.find<ProductsController>(); // Moved inside build

  @override
  void initState() {
    super.initState();
    // No need for manual scroll logic initiation here
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        // ... (Empty state handling) ...
        return Container(/* ... placeholder ... */);
      }

      // --- CALCULATE WEB VIEWPORT FRACTION ---
      // Decide how much of the screen width one card should roughly take on web
      // e.g., if you want about 3 cards visible, use 1/3 = 0.33
      // Let's try making the card width (350 + padding) a fraction of a typical web width (e.g., 1000px)
      // Or simply choose a smaller fraction for web.
      const double webCardWidth = 450; // The fixed width you chose
      const double webPadding = 20; // 5px on each side
      // Aim for a fraction that makes the card fill most of the slot
      // Let's try showing roughly 2.5 items on web, so maybe 1/2.5 = 0.4
      final double webViewportFraction = 0.32; // Adjust this value (try 0.3, 0.35, 0.4, 0.5)

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text("Featured Products".tr),
            const SizedBox(height: 20),
            SizedBox(
              height: 450,
              child: CarouselSlider.builder(
                key: ValueKey(products.length),
                itemCount: products.length,
                itemBuilder: (context, index, realIdx) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      // Keep the conditional width for the card itself
                      width: isMobile ? screenWidth * 0.9 : webCardWidth,
                      child: _buildCard(context, product),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 380,
                  // *** Make viewportFraction conditional ***
                  viewportFraction: isMobile ? 0.85 : webViewportFraction,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: products.length > 1,
                  autoPlayInterval: const Duration(seconds: 4),
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- Helper Methods ---

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Consider showing a Get.snackbar error
      print('Could not launch $uri');
      // throw Exception('Could not launch $uri'); // Avoid throwing exceptions directly from UI interaction
    }
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double remainder = rating - fullStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    if (remainder >= 0.25 && remainder < 0.75) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
      fullStars++;
    } else if (remainder >= 0.75) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
      fullStars++;
    }
    for (int i = fullStars; i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Widget _buildCard(BuildContext context, Project product) {
    return InkWell(
      onTap: () {
        if (product.projectId == null || product.projectId!.isEmpty) {
          print("Error: Product ID is missing for '${product.title}', cannot navigate.");
          Get.snackbar(
            'Navigation Error',
            'Cannot view details for this product (missing ID).',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        // Navigate to Product Detail Page using named route with parameters
        Get.toNamed(
          '/product-detail/:projectId', // Route pattern defined in GetMaterialApp
          parameters: {
            'projectId': product.projectId!, // Pass the actual ID
          },
          arguments: product, // Pass the full object for the logic controller
        );
      },
      child: Container(
        // Outer Container for Card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          // Main Column for Card Content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Children of Main Column
            // --- Child 1: Image ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.thumbnailUrl ??
                    'https://via.placeholder.com/300x200?text=No+Image',
                width: double.infinity,
                height: 200,
                // Fixed image height
                fit: BoxFit.cover,
                // Optional: Add loading/error builders for Image.network
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, color: Colors.grey[400]),
                    ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- Child 2: Details Padding ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                // Column for Text details
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.subtitle ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // Row for Price and Rating
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price?.toStringAsFixed(0) ?? 'N/A'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      _buildRatingStars(product.rating ?? 4.5), // Default rating if null
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    // Row for Sales and Add-to-Cart Button
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // Sales Count
                        "${product.soldCount ?? 0} Sales",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      OutlinedButton(
                        // Add to Cart Button
                        onPressed: () {
                          cartController.add(product);
                          // Removed print statement
                          Get.snackbar(
                            'Added to Cart',
                            '${product.title ?? 'Item'} added!',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                            mainButton: TextButton(
                              onPressed: () {
                                Get.toNamed(
                                  CartPage.routeName,
                                ); // Use route name from CartPage
                              },
                              child: const Text(
                                'VIEW CART',
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(36, 36), // Make button compact
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart, // Changed icon slightly
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ], // End Text Column Children
              ), // End Text Column
            ), // End Padding

            // *** The comma was missing after the Padding widget ***
          ], // End Main Column Children
        ), // End Main Column
      ), // End Outer Container
    ); // End InkWell
  }

  @override
  void dispose() {
    // Only cancel timer if it exists (it doesn't in this version)
    // _autoScrollTimer?.cancel();
    // Only dispose controller if it exists (it doesn't in this version)
    // _scrollController.dispose();

    // Consider if CartLogic should be deleted here or managed globally
    // Get.delete<CartLogic>(); // Usually NOT deleted here if needed elsewhere

    super.dispose();
  }
}
