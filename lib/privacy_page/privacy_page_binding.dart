import 'package:get/get.dart';

import 'privacy_page_logic.dart';

class PrivacyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPageLogic());
  }
}
