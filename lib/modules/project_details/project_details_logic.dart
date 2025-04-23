import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your Project model
import '../../models/products.dart';
import '../cart/cart_logic.dart';

class ProjectDetailsLogic extends GetxController {
  final CartLogic cartLogic = Get.find<CartLogic>();
  final Rx<Project?> product = Rx<Project?>(null);
  final RxInt currentImageIndex = 0.obs;
  final RxList<String> imagesToShow = <String>[].obs;

  bool get isProductLoaded => product.value != null;

  @override
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

  void _loadProductFromArguments() {
    if (Get.arguments is Project) {
      product.value = Get.arguments as Project;
      _updateImagesToShow();
    } else {
      Get.snackbar('Error', 'Could not load product details.');
      Get.back(); // Optionally navigate back if data is missing
    }
  }

  void _updateImagesToShow() {
    if (product.value == null) return;

    // 1. Safely get the thumbnail URL
    final String? thumbnailUrl = product.value!.thumbnailUrl;

    // 2. Safely get shotUrls, ensuring they are treated as Strings
    //    Map dynamic list (if it is) to List<String>, converting non-strings or nulls if necessary
    final List<String> shotUrlsList = (product.value!.demoAdminPanelLinks!?? [])
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

    print("Updated imagesToShow: ${imagesToShow.length} images"); // Optional: Debug log
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
