import 'dart:async';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:privatily_app/modules/allProjects/allProjects.dart';
import 'package:privatily_app/widgets/translationsController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seo/seo.dart'; // SEO package

import '../../../animations/price.dart';
import '../../../models/products.dart';
import '../../../utils/translationHelper.dart';
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
  final translationController = Get.put(TranslationController());

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
           Wrap(
             // mainAxisAlignment: MainAxisAlignment.center,
             alignment: WrapAlignment.center,
              children: [
                Center(
                  child: Text(
                    'discover_software'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 16 : 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Gap(12),
                ElevatedButton(onPressed: (){

                  Get.toNamed('/allProducts');
                }, child: Text('explore_products'.tr))
              ],
            ),
            const Gap(5),
            SizedBox(
              width: double.infinity,
              height: isMobile ? 320 : 450,
              child: CarouselSlider.builder(
                itemCount: products.length,
                itemBuilder: (context, index, realIdx) {
                  final product = products[index];
                  return _buildCard(context, product);
                },
                options: CarouselOptions(
                  height: isMobile ? 320 : 400,
                  viewportFraction:
                      isMobile
                          ? 0.95
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

    // Define the WhatsApp URL. You'll need the phone number.
    // Replace 'YOUR_PHONE_NUMBER' with the actual phone number, including country code.
    // You can also add a pre-filled message using '&text=Your message here'.
    final whatsappUrl =
        "whatsapp://send?phone=+923058431046&text=I'm interested in your product: ${product.title}";

    return Seo.link(
      href: '/product-detail/${product.projectId}',
      anchor: product.title ?? 'Product',
      child: InkWell(
        onTap: () {
          if (product.projectId?.isNotEmpty != true) {
            Get.snackbar('Error', 'Missing product ID');
            return;
          }
          Get.toNamed('/product-detail/${product.projectId}', arguments: product);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Use a Stack to layer the image and the WhatsApp icon
                Stack(
                  children: [
                    // Product image wrapped in SEO image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      child: Seo.image(
                        src: product.thumbnailUrl ?? '',
                        alt: product.title ?? 'Product image',
                        child: Image.network(
                          product.thumbnailUrl ??
                              'https://via.placeholder.com/300x200?text=No+Image',
                          height: isMobile ? 215 : 295,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          loadingBuilder: (ctx, child, progress) {
                            return progress == null ? child : const MyLoader();
                          },
                          errorBuilder:
                              (ctx, _, __) => Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                    // WhatsApp icon positioned at the top right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final Uri uri = Uri.parse(whatsappUrl);
                          if (!await launchUrl(uri)) {
                            Get.snackbar('Error', 'Could not launch WhatsApp');
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
                            // Using a generic WhatsApp icon from Material Icons
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              child: FutureBuilder<String>(
                                future: TranslationService.translateText(
                                  product.title ?? 'No Title',
                                  Get.locale?.languageCode ?? 'en',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('...');
                                  } else if (snapshot.hasError) {
                                    return Text('No Title'); // fallback to original
                                  } else {
                                    return Text(
                                      snapshot.data ?? 'No Title',
                                      style: Theme.of(context).textTheme.titleSmall
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    );
                                  }
                                },
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
                        child:
                        FutureBuilder<String>(
                          future: TranslationService.translateText(
                            product.subtitle?? 'No Subtitle',
                            Get.locale?.languageCode ?? 'en',
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('...');
                            } else if (snapshot.hasError) {
                              return Text('No Subtitle'); // fallback to original
                            } else {
                              return Text(
                                snapshot.data ?? 'No Subtitle',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              );
                            }
                          },
                        ),


                      ),
                      const Gap(4),
                      // Price and sales count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Seo.text(
                          //   text: '\$${product.price?.toStringAsFixed(0) ?? 'N/A'}',
                          //   style: TextTagStyle.h4,
                          //   child: Text(
                          //     '\$${product.price?.toStringAsFixed(0) ?? 'N/A'}',
                          //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          //   ),
                          // ),



                          Seo.text(
                            text: 'Deployed ${product.soldCount ?? 0} times',
                            style: TextTagStyle.p,
                            child:


                            FutureBuilder<String>(
                              future: TranslationService.translateText(
                                "Deployed ${product.soldCount ?? 0} times"?? 'No Data',
                                Get.locale?.languageCode ?? 'en',
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('...');
                                } else if (snapshot.hasError) {
                                  return Text('No Data'); // fallback to original
                                } else {
                                  return Text(
                                    snapshot.data ?? 'No Data',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  );
                                }
                              },
                            ),



                          ),
                        ],
                      ),
                      // Add to cart button
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       cartController.add(product);
                      //       Get.snackbar(
                      //         'Added',
                      //         '${product.title} added to cart',
                      //         snackPosition: SnackPosition.BOTTOM,
                      //         mainButton: TextButton(
                      //           onPressed: () => Get.toNamed(CartPage.routeName),
                      //           child: const Text('VIEW CART'),
                      //         ),
                      //       );
                      //     },
                      //     icon: const Icon(Icons.add_shopping_cart, size: 18),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
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
