import 'package:get/get.dart';

import '../../models/products.dart';

class CartLogic extends GetxController {


  // Use RxList to make the list reactive
  final items = <Project>[].obs;

  // Getter for item count (automatically reactive)
  int get itemCount => items.length;

  // Getter for total amount (automatically reactive)
  double get totalAmount {
  // Use fold on the reactive list
  return items.fold(0.0, (sum, item) => sum + (item.price ?? 0).toDouble());
  }

  void add(Project project) {
  items.add(project);
  print('GetX: Added ${project.title}. Total: $itemCount');
  // No need for notifyListeners(), Rx does it.
  }

  void remove(Project project) {
  items.remove(project);
  print('GetX: Removed ${project.title}. Total: $itemCount');
  }

  void clear() {
  items.clear();
  print('GetX: Cart cleared.');
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
