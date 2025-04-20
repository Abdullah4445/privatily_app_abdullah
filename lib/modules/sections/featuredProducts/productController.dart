import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/products.dart';

class ProductsController extends GetxController {
  final RxList<Project> products = <Project>[].obs;
  final RxBool isLoading = false.obs;

  // Dummy image URLs (used if Firestore fetch fails or is empty)
  final List<String> imageUrls = [
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.51.41%E2%80%AFAM.png?alt=media&token=5ded4324-7f0c-4269-a1ba-5d54ceff48e2",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.53.32%E2%80%AFAM.png?alt=media&token=efd74385-6cca-4998-8ddb-7603c1024e42",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.55.39%E2%80%AFAM.png?alt=media&token=730eb7f6-1e7d-4b06-b5b2-b62ed8f7671c",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
    "https://firebasestorage.googleapis.com/v0/b/billtech-6f3b1.appspot.com/o/Screenshot%202025-04-14%20at%209.56.16%E2%80%AFAM.png?alt=media&token=775a946f-0b2d-4858-80fc-4cf13fa5e940",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTopProducts(); // Load products when the controller is initialized
  }

  Future<void> fetchTopProducts() async {
    isLoading.value = true;
    try {
      // Clear the existing products list
      products.clear();

      // Fetch projects from Firestore, ordered by creation date
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .get();

      // Print the number of documents fetched for debugging
      print("My total documents fetched are: ${snapshot.docs.length}");

      // Convert each document into a Project object using the fromJson factory
      if (snapshot.docs.isNotEmpty) {
        final List<Project> fetchedProjects = snapshot.docs
            .map((doc) => Project.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        products.assignAll(fetchedProjects); // Use assignAll for better performance
      } else {
        // Handle the case where there are no products in Firestore.
        //  Important:  Don't just leave it empty.  The UI should reflect this.
        print("No projects found in Firestore.  Using dummy data.");
        products.assignAll(List.generate(9, (i) => Project(
          title: 'Project ${i + 1}',
          subtitle: 'Awesome software tool for startup growth',
          thumbnailUrl: imageUrls[i],
          price: 0, //  set default
          projectDesc: "Description",
          projectId: "id$i",
          projectLink: "link",


        ))); //set dummy data
      }
    } catch (error) {
      // Handle errors appropriately (e.g., show a message to the user)
      print('❌ Error fetching products: $error');
      //  Consider showing a dialog or snackbar to the user to inform them of the error
      Get.snackbar(
        "Error",
        "Failed to load products: $error",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Even on error, you might want to set a default state, or an empty list
      products.assignAll([]); // Or some default value to prevent UI errors.

    } finally {
      isLoading.value = false; // Ensure isLoading is set to false
    }
  }
}
