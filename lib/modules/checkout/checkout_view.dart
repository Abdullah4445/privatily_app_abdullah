import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the logic controller
import 'checkout_logic.dart';
// Import CartLogic to display total amount (assuming it's needed directly)
import '../cart/cart_logic.dart'; // <--- ADJUST IMPORT PATH

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);
  // Optional: Define routeName if using GetX named routes
  static const routeName = '/checkout';

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Put the controller instance specific to this page's lifecycle
  // If checkout state needs to persist globally or across complex navigation,
  // consider using Bindings instead.
  final CheckoutLogic logic = Get.put(CheckoutLogic());
  // Find the global CartLogic instance to display total etc.
  final CartLogic cartLogic = Get.find<CartLogic>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double displayTotal = cartLogic.totalAmount; // Get total from CartLogic

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 1,
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Order Summary'),
              _buildOrderSummaryCard(context, displayTotal, theme),
              const SizedBox(height: 24),

              _buildSectionTitle(context, 'Shipping Address'),
              _buildShippingCard(context, theme),
              const SizedBox(height: 24),

              _buildSectionTitle(context, 'Payment Method'),
              _buildPaymentCard(context, theme),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPlaceOrderButton(context, displayTotal, theme, logic), // Pass logic here
    );
  }

  // --- Helper Widgets (Copied from previous example, kept static in View) ---

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, double total, ThemeData theme) {
    // This card now just displays data, logic isn't needed here
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items Total:', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                // Get total directly from cartLogic or passed variable
                Text('\$${total.toStringAsFixed(0)}', style: theme.textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping:', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                Text('Free', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green[700])),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grand Total:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingCard(BuildContext context, ThemeData theme) {
    // Placeholder - no direct logic interaction here
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Icon(Icons.local_shipping_outlined, color: theme.primaryColor, size: 30),
        title: Text('123 Flutter Lane', style: theme.textTheme.bodyLarge),
        subtitle: Text('Cityville, FL 12345', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        trailing: TextButton(
          onPressed: () { Get.snackbar('Info', 'Address selection TBD.'); },
          child: const Text('Change'),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, ThemeData theme) {
    // Placeholder - no direct logic interaction here
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Icon(Icons.credit_card, color: theme.primaryColor, size: 30),
        title: Text('Visa **** **** **** 4444', style: theme.textTheme.bodyLarge),
        subtitle: Text('Expires 12/2026', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        trailing: TextButton(
          onPressed: () { Get.snackbar('Info', 'Payment selection TBD.'); },
          child: const Text('Change'),
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context, double total, ThemeData theme, CheckoutLogic checkoutLogic) {
    // This widget needs to react to the loading state from CheckoutLogic
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 0, blurRadius: 10) ],
      ),
      // Use Obx to listen ONLY to the isLoading state from the passed logic controller
      child: Obx(() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          disabledBackgroundColor: checkoutLogic.isLoading.value ? theme.colorScheme.secondary.withOpacity(0.5) : Colors.grey.shade300,
          disabledForegroundColor: checkoutLogic.isLoading.value ? theme.colorScheme.onSecondary.withOpacity(0.7) : Colors.grey.shade500,
        ),
        // Disable button if total is zero OR if logic.isLoading is true
        onPressed: (total <= 0 || checkoutLogic.isLoading.value)
            ? null
            : () => checkoutLogic.placeOrder(), // Call the logic method
        child: checkoutLogic.isLoading.value // Check loading state from logic
            ? const SizedBox( // Show loading indicator
          height: 24, width: 24,
          child: CircularProgressIndicator( strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        )
            : const Text('Place Order'), // Show button text
      ),
      ),
    );
  }


  @override
  void dispose() {
    // Delete the controller instance when this page is disposed
    // Only do this if the controller was put() here and is page-specific.
    // If using Bindings or global put(), DO NOT delete here.
    print("Disposing CheckoutPage, deleting CheckoutLogic");
    Get.delete<CheckoutLogic>();
    super.dispose();
  }
}