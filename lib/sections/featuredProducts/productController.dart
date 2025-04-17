import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Product {
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final double regularPrice;
  final String builtBy;
  final int soldCount;
  final DateTime? updatedAt;

  Product({
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.regularPrice,
    required this.builtBy,
    required this.soldCount,
    required this.updatedAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      regularPrice: (data['regularPrice'] ?? 0).toDouble(),
      builtBy: data['builtBy'] ?? '',
      soldCount: data['soldCount'] ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ProductsController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() async{
    isLoading.value = true;
    await fetchTopProducts();
    isLoading.value = false;
    update();
    super.onInit();
  }
  var imageUrls = [
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

   Future<void> fetchTopProducts() async {
    products.clear();
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(4)
          .get();

      if (snapshot.docs.isNotEmpty) {
        products.value = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      } else {
        // Dummy fallback
        products.value = List.generate(9, (i) => Product(
          title: 'Product ${i + 1}',
          subtitle: 'Awesome software tool for startup growth',
          thumbnailUrl: imageUrls[i + 1],
          regularPrice: 0,
          builtBy: 'LaunchCode',
          soldCount: 0,
          updatedAt: null,
        ));
      }
    } catch (e) {
      print('❌ Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
