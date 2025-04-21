import 'package:get/get.dart';

import 'project_details_logic.dart';

class ProjectDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectDetailsLogic());
  }
}
