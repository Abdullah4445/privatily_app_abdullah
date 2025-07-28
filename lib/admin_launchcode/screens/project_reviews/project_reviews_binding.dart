import 'package:get/get.dart';

import 'project_reviews_logic.dart';

class ProjectReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectReviewsLogic());
  }
}
