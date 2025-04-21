import 'package:flutter/material.dart'; // For Colors
import 'package:get/get.dart';
import '../cart/cart_logic.dart'; // <--- ADJUST IMPORT PATH (To your Cart Logic)

class CheckoutLogic extends GetxController {
  // Dependency Injection: Find the globally available CartLogic
  // Assumes CartLogic is already put() elsewhere (e.g., in main.dart or via Bindings)
  final CartLogic cartLogic = Get.find<CartLogic>();

  // --- State ---
  // Observable boolean to track loading state for the place order button
  final isLoading = false.obs;

  // --- Actions ---

  // Method to handle placing the order
  Future<void> placeOrder() async {
    if (isLoading.value) return; // Prevent multiple simultaneous calls

    try {
      isLoading.value = true; // Set loading state to true

      // --- Simulate Network Request/Processing ---
      print('CheckoutLogic: Simulating order placement...');
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      print('CheckoutLogic: Order simulation complete.');
      // --- End Simulation ---

      // ** TODO: Replace simulation with your actual backend API call **
      // Example:
      // bool success = await MyApiService.placeOrder(
      //   items: cartLogic.items.toList(), // Pass cart items
      //   total: cartLogic.totalAmount,
      //   // Pass shipping details, payment token etc.
      // );
      // if (!success) {
      //   throw Exception('Failed to place order via API.');
      // }

      // If successful (or simulation ends):
      // 1. Clear the cart
      cartLogic.clear();

      // 2. Show Success Feedback (using GetX snackbar)
      Get.snackbar(
        'Order Placed!',
        'Your order has been placed successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: EdgeInsets.zero,
        borderRadius: 0,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      // 3. Navigate away (e.g., back to home screen, remove all previous routes)
      // Replace '/' with your actual home route name if different
      Get.offAllNamed('/');

    } catch (error) {
      // Handle errors during the process
      print("CheckoutLogic Error placing order: $error");
      Get.snackbar(
        'Error',
        'Could not place order. Please try again.', // Keep error message user-friendly
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      // Ensure loading state is always reset
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    print("CheckoutLogic Ready");
    super.onReady();
  }

  @override
  void onClose() {
    print("CheckoutLogic Closing");
    super.onClose();
  }
}