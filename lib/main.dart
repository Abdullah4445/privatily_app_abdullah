import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privatily_app/translation/app_translations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'firebase_options.dart';
import 'modules/cart/cart_view.dart';
import 'modules/checkout/checkout_view.dart';
import 'modules/project_details/project_details_view.dart';
import 'modules/sections/featuredProducts/productController.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'widgets/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Register controllers before runApp
  Get.put(ProductsController()); // 🔥 Makes ProductsController globally available

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LaunchCode',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: '/', // Or your home route name
      getPages: [ // Define routes for Get.toNamed
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: CartPage.routeName, page: () => const CartPage()),
        GetPage(name: CheckoutPage.routeName, page: () => const CheckoutPage()),
        GetPage(
          name: '/product-detail/:projectId', // <--- ADD Parameter placeholder here
          page: () => const ProjectDetailsPage(), // The view remains the same
          // Optional: Define bindings if you prefer over Get.put/find in view/logic
          // binding: ProjectDetailsBinding(),
        ),
        // Add other GetPage entries
      ],

      // ✅ FIXED: Provide MaterialLocalizations
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('es', 'ES'),
      //   Locale('fr', 'FR'),
      //   Locale('ar', 'AR'),
      // ],

      // ✅ Home screen
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 520, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const Home(),
    );
  }
}
