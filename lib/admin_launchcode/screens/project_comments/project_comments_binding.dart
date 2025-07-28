import 'package:get/get.dart';

import 'project_comments_logic.dart';

class ProjectCommentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectCommentsLogic());
  }
}
