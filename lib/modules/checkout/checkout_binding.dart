import 'package:get/get.dart';

import 'checkout_logic.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutLogic());
  }
}
