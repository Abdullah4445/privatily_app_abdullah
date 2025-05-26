import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
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



    int crossAxisCount = ResponsiveBreakpoints.of(context).largerThan(TABLET)
        ? 3
        : ResponsiveBreakpoints.of(context).largerThan(MOBILE)
        ? 2
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
            ),
            const SizedBox(height: 20),
            // Products Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = controller.products.where((product) {
                  final query = searchQuery.value;
                  final title = product.title?.toLowerCase() ?? '';
                  final subtitle = product.subtitle?.toLowerCase() ?? '';
                  return title.contains(query) || subtitle.contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No products found."));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 590 / 520,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/product-detail/${product.projectId}', arguments: product);
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: SizedBox(
                                width: double.infinity,
                                height: 250,
                                child: Image.network(
                                  product.thumbnailUrl ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Translated Title
                                  FutureBuilder<String>(
                                    future: TranslationService.translateText(
                                      product.title ?? '',
                                      Get.locale?.languageCode ?? 'en',
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('Loading title...');
                                      } else if (snapshot.hasError) {
                                        return Text(product.title ?? 'No Title');
                                      } else {
                                        return Text(
                                          snapshot.data ?? product.title ?? 'No Title',
                                          style: const TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 4),

                                  // Translated Subtitle
                                  FutureBuilder<String>(
                                    future: TranslationService.translateText(
                                      product.subtitle ?? '',
                                      Get.locale?.languageCode ?? 'en',
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text('Loading subtitle...');
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          product.subtitle ?? 'No Subtitle',
                                          style:
                                          const TextStyle(fontSize: 14, color: Colors.black54),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data ?? product.subtitle ?? 'No Subtitle',
                                          style:
                                          const TextStyle(fontSize: 14, color: Colors.black54),
                                        );
                                      }
                                    },
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
