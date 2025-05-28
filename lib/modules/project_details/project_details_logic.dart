import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your Project model
import '../../models/products.dart';
import '../../utils/translationHelper.dart';
import '../cart/cart_logic.dart';

class ProjectDetailsLogic extends GetxController {
  final CartLogic cartLogic = Get.find<CartLogic>();
  final Rx<Project?> product = Rx<Project?>(null);
  final RxInt currentImageIndex = 0.obs;
  final RxList<String> imagesToShow = <String>[].obs;

  bool get isProductLoaded => product.value != null;
  final isDescriptionExpanded = false.obs;

  void toggleDescriptionExpansion() {
    isDescriptionExpanded.toggle();
    print('isDescriptionExpanded toggled to: ${isDescriptionExpanded.value}');
  }

  Widget buildThumbnail(BuildContext context, String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return const SizedBox.shrink(); // Or a placeholder
    }

    return GestureDetector(
      onTap: () {
        _openImagePreview(context, thumbnailUrl);
      },
      child: Center(
        child: Hero(
          tag: thumbnailUrl, // Unique tag for Hero animation
          child: Image.network(
            thumbnailUrl,
            height: 200,
            width: 490,
            fit: BoxFit.contain, // Or BoxFit.cover depending on your preference
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
        ),
      ),
    );
  }

  void _openImagePreview(BuildContext context, String imageUrl) {
    final TransformationController transformationController = TransformationController();
    double scale = 1.0;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 5.0,
                    transformationController: transformationController,
                    child: Hero(
                      tag: imageUrl,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100, color: Colors.white);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    right: 16,
                    child: Column(
                      children: [
                        // Zoom In Button
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.zoom_in, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                scale = (scale + 0.2).clamp(1.0, 5.0);
                                final focalPoint = MediaQuery.of(context).size.center(Offset.zero);
                                transformationController.value = Matrix4.identity()
                                  ..translate(
                                    focalPoint.dx * (1 - scale),
                                    focalPoint.dy * (1 - scale),
                                  )
                                  ..scale(scale);
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Zoom Out Button
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.zoom_out, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                scale = (scale - 0.2).clamp(1.0, 5.0);
                                final focalPoint = MediaQuery.of(context).size.center(Offset.zero);
                                transformationController.value = Matrix4.identity()
                                  ..translate(
                                    focalPoint.dx * (1 - scale),
                                    focalPoint.dy * (1 - scale),
                                  )
                                  ..scale(scale);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    // --- Primary: Load full object from arguments ---
    _loadProductFromArguments(); // This method should check Get.arguments

    // --- Optional: Access and log the parameter from the URL ---
    final String? idFromUrl = Get.parameters['projectId'];
    if (idFromUrl != null) {
      print("ProjectDetailsLogic: Navigated via URL parameter projectId: $idFromUrl");
      // You could add validation here:
      if (product.value != null && product.value!.projectId != idFromUrl) {
        print("Warning: Product ID from argument (${product.value!.projectId}) "
            "does not match URL parameter ($idFromUrl). Prioritizing argument.");
      }
      // Or potentially use idFromUrl to fetch data if Get.arguments was null
    } else {
      print("Warning: ProjectDetailsLogic could not find 'projectId' in Get.parameters.");
      // This might happen if navigated differently or route mismatch
    }
  }

  void _loadProductFromArguments() async {
    if (Get.arguments is Project) {
      product.value = Get.arguments as Project;
      await translateProjectDescriptionIfNeeded();
      _updateImagesToShow();
    } else {

      // Try fallback: use URL param to fetch from Firestore

      final String? idFromUrl = Get.parameters['projectId'];


      if (idFromUrl != null && idFromUrl.isNotEmpty) {

        try {
          final docSnapshot = await FirebaseFirestore.instance
              .collection('projects')
              .doc(idFromUrl)
              .get();


          if (docSnapshot.exists) {

            product.value = Project.fromJson(docSnapshot.data()!);

            _updateImagesToShow();
          } else {
            Get.snackbar('Not Found', 'No product found for this link.');
            Get.back();
          }
          await translateProjectDescriptionIfNeeded();
        } catch (e) {
          Get.snackbar('Error', 'Failed to load product.');
          Get.back();
        }

      } else {

        Get.snackbar('Error', 'Missing product ID.');
        Get.back();
      }
    }
  }


  void _updateImagesToShow() {
    if (product.value == null) return;

    // 1. Safely get the thumbnail URL
    final String? thumbnailUrl = product.value!.thumbnailUrl;

    // 2. Safely get shotUrls, ensuring they are treated as Strings
    //    Map dynamic list (if it is) to List<String>, converting non-strings or nulls if necessary
    final List<String> shotUrlsList = (product.value!.demoAdminPanelLinks!)
        .map((dynamic url) {
      // Ensure each element is treated as a string, return empty if not
      return (url is String) ? url : '';
    })
        .where((url) => url.isNotEmpty) // Filter out empty strings (original or converted)
        .toList(); // Create a definite List<String>

    // 3. Combine thumbnail (if valid) and the processed shotUrls
    final List<String> combinedImages = [
      // Add thumbnail only if it's a non-empty string
      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) thumbnailUrl,
      // Spread the guaranteed List<String>
      ...shotUrlsList,
    ];

    // 4. Assign the final List<String> to the RxList
    imagesToShow.assignAll(combinedImages);

  }
  Future<void> translateProjectDescriptionIfNeeded() async {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'en' || product.value == null) return;

    try {
      final translatedDesc = await TranslationService.translateText(product.value!.projectDesc ?? '', lang);
      final translatedTitle = await TranslationService.translateText(product.value!.title ?? '', lang);
      final translatedSubtitle = await TranslationService.translateText(product.value!.subtitle ?? '', lang);

      product.value = product.value!.copyWith(
        title: translatedTitle,
        subtitle: translatedSubtitle,
        projectDesc: translatedDesc,
      );
    } catch (e) {
      print("Translation error: $e");
    }
  }

 

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void addToCart() {
    if (product.value == null) return;
    cartLogic.add(product.value!);
    Get.snackbar(
      'Added to Cart',
      '${product.value!.title ?? 'Item'} added!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      mainButton: TextButton(
        onPressed: () => Get.toNamed('/cart'),
        child: const Text('VIEW CART', style: TextStyle(color: Colors.amber)),
      ),
    );
  }

  Future<void> launchUrlExternal(String? urlString) async {
    if (urlString != null && urlString.isNotEmpty) {
      final Uri uri = Uri.parse(urlString);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not launch URL: $urlString',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white);
      }
    } else {
      Get.snackbar('Info', 'No URL provided.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat.yMMMd().add_jm().format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
