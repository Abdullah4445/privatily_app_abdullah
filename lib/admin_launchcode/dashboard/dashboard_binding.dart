
import 'package:get/get.dart';
import 'package:privatily_app/admin_launchcode/projects/projects_controller.dart';
import 'package:privatily_app/admin_launchcode/screens/project_comments/project_comments_logic.dart';

import 'dashboard_logic.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminDashboardLogic());
    Get.lazyPut(() => ProjectCommentsLogic());
    Get.lazyPut(() => ProjectController());
  }
}
