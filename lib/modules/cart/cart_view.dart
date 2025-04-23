import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/products.dart';
import '../../widgets/myProgressIndicator.dart';
import '../checkout/checkout_view.dart';
import 'cart_logic.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  static const routeName = '/cart'; // Make sure this route is defined in GetMaterialApp

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Get (or create) the CartLogic instance using GetX dependency management
  // Using Get.find() is generally preferred if the controller is put elsewhere (e.g., in main or Bindings)
  // Using Get.put() here means this specific instance is tied to this widget's lifecycle
  // If the cart needs to persist globally, put it higher up the tree.
  final CartLogic logic = Get.put(CartLogic());

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Get theme data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        elevation: 1, // Subtle shadow
        backgroundColor: theme.canvasColor, // Match background
        foregroundColor: theme.textTheme.titleLarge?.color, // Use text color
      ),
      body: Obx(() { // Use Obx to automatically react to changes in logic.items
        if (logic.items.isEmpty) {
          return _buildEmptyCart(context);
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: logic.itemCount,
                  itemBuilder: (ctx, index) {
                    final item = logic.items[index];
                    return _buildCartItem(context, item, logic);
                  },
                ),
              ),
              _buildSummaryCard(context, logic, theme), // Pass theme
            ],
          );
        }
      }),
    );
  }

  // --- Helper Widgets ---

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Your Cart is Empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          Text(
            'Looks like you haven\'t added anything yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Start Shopping'),
            onPressed: () {
              // Navigate back or to the main product list screen
              if (Get.previousRoute.isNotEmpty) {
                Get.back();
              } else {
                // Get.offAllNamed('/'); // Or your home route
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Project item, CartLogic logic) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.thumbnailUrl ?? 'https://via.placeholder.com/80?text=No+Image',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, color: Colors.grey[400]),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(
                      child: MyLoader(
                        // strokeWidth: 2.0,
                        // value: loadingProgress.expectedTotalBytes != null
                        //     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        //     : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            // Title and Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'No Title',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${(item.price ?? 0).toStringAsFixed(0)}', // Assuming price is int
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error.withOpacity(0.8)),
              tooltip: 'Remove item',
              onPressed: () {
                // Confirmation Dialog using GetX
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    title: const Text('Confirm Deletion'),
                    content: Text('Remove "${item.title ?? 'this item'}" from your cart?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Get.back(result: false), // Close dialog, return false
                      ),
                      TextButton(
                        child: Text('Remove', style: TextStyle(color: theme.colorScheme.error)),
                        onPressed: () => Get.back(result: true), // Close dialog, return true
                      ),
                    ],
                  ),
                  barrierDismissible: false, // User must tap button
                ).then((confirmed) {
                  if (confirmed == true) {
                    logic.remove(item);
                    // Optional: Show a snackbar confirmation
                    Get.snackbar(
                        'Removed',
                        '"${item.title ?? 'Item'}" removed from cart.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(12),
                        backgroundColor: Colors.grey[700],
                        colorText: Colors.white
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, CartLogic logic, ThemeData theme) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes minimum vertical space
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Subtotal:',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  '\$${logic.totalAmount.toStringAsFixed(0)}', // Format total
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // You could add lines for Tax, Shipping etc. here if needed
            Divider(height: 20, thickness: 1, color: Colors.grey[200]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total:',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${logic.totalAmount.toStringAsFixed(0)}', // Format total
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Make button full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: theme.colorScheme.secondary, // Use accent/secondary color
                    foregroundColor: theme.colorScheme.onSecondary, // Text color on secondary
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded button
                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                ),
                // Disable button if cart is empty (totalAmount is 0)
                onPressed: (logic.totalAmount <= 0)
                    ? null
                    : () {
                  // Navigate to Checkout using GetX
                  Get.toNamed(CheckoutPage.routeName);
                  // Or use named route if defined:
                  // Get.toNamed('/checkout', arguments: logic.totalAmount);
                },
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // IMPORTANT: Only delete the controller IF it was put() exclusively for this page
    // and should not persist when the user navigates away.
    // If the cart state needs to be preserved globally (most common case),
    // CartLogic should be managed by GetX Bindings or put() higher up (e.g., in main.dart)
    // and should NOT be deleted here.
    // Get.delete<CartLogic>(); // <--- COMMENT THIS OUT if cart should persist globally
    super.dispose();
  }
}