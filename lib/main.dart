import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privatily_app/translation/app_translations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'firebase_options.dart';
import 'firebase_utils.dart';
import 'modules/cart/cart_view.dart';
import 'modules/checkout/checkout_view.dart';
import 'modules/project_details/project_details_view.dart';
import 'modules/sections/featuredProducts/productController.dart';
import 'widgets/home.dart';

// SEO imports for Flutter Web
import 'package:seo/seo.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use clean URLs (no hash) for SEO-friendly paths
  // setUrlStrategy(PathUrlStrategy());
  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Get the current user after Firebase initialization
  final user = FirebaseAuth.instance.currentUser;

  // Call setUserOnline if the user is already logged in
  if (user != null) {
    await setUserOnline();
  }
  // Register controllers before runApp
  Get.put(ProductsController());

  // Launch the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app in SeoController within a BuildContext
    return SeoController(
      enabled: true,
      // Provide default meta tags
      // tags: [
      //   MetaTag(name: 'viewport', content: 'width=device-width, initial-scale=1'),
      //   MetaTag(charset: 'utf-8'),
      // ],
      // Pass the context to generate <head> and <body> tree
      tree: WidgetTree(context: context),
      child: GetMaterialApp(
        title: 'LaunchCode',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(name: CartPage.routeName, page: () => const CartPage()),
          GetPage(name: CheckoutPage.routeName, page: () => const CheckoutPage()),
          GetPage(
            name: '/product-detail/:projectId',
            page: () => const ProjectDetailsPage(),
          ),
        ],
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 520, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        // Remove `home` when using initialRoute
        // home: const Home(),
      ),
    );
  }
}
