import 'package:get/get.dart';

import 'dashboard_state.dart';

class AdminDashboardLogic extends GetxController {
  final DashboardState state = DashboardState();
  // Track the selected screen index
  var selectedScreenIndex = 0.obs;

  // Function to change the selected screen
  void changeScreen(int index) {
    selectedScreenIndex.value = index;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
