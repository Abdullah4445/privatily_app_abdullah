import 'package:get/get.dart';

import 'terms_and_conditions_logic.dart';

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermsAndConditionsLogic());
  }
}
