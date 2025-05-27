import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/products.dart';
import '../../utils/translationHelper.dart';
import '../sections/featuredProducts/productController.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});
  static const routeName = '/allProducts';

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final ProductsController controller = Get.put(ProductsController());
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final crossAxisCount = breakpoints.largerThan(TABLET)
        ? 3
        : breakpoints.largerThan(MOBILE)
        ? 2
        : 1;

    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
            ),
            const SizedBox(height: 20),

            /// 🛍️ Product grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final results = controller.products.where((p) {
                  final q = searchQuery.value;
                  return (p.title ?? '').toLowerCase().contains(q) ||
                      (p.subtitle ?? '').toLowerCase().contains(q);
                }).toList();

                if (results.isEmpty) {
                  return const Center(child: Text("No products found."));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: breakpoints.isMobile ? 490 / 520 : 590 / 490,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, i) {
                    final product = results[i];

                    /// WhatsApp deeplink (change number if needed)
                    final whatsappUrl = Uri.parse(
                      "https://wa.me/923058431046?text=${Uri.encodeComponent(
                        "I'm interested in your product: Name:${product.title} — id:${product.projectId}",
                      )}",
                    );

                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        '/product-detail/${product.projectId}',
                        arguments: product,
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 📷 Image + WhatsApp overlay
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 250,
                                    child: Image.network(
                                      product.thumbnailUrl ?? '',
                                      fit: BoxFit.fill,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (!await launchUrl(
                                        whatsappUrl,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        Get.snackbar(
                                          'Error',
                                          'Could not launch WhatsApp',
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            /// 📝 Title & subtitle
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String>(
                                    future: TranslationService.translateText(
                                      product.title ?? '',
                                      Get.locale?.languageCode ?? 'en',
                                    ),
                                    builder: (_, snap) => Text(
                                      snap.data ?? product.title ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder<String>(
                                    future: TranslationService.translateText(
                                      product.subtitle ?? '',
                                      Get.locale?.languageCode ?? 'en',
                                    ),
                                    builder: (_, snap) => Text(
                                      snap.data ?? product.subtitle ?? 'No Subtitle',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
