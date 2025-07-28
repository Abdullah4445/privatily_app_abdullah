import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privatily_app/admin_launchcode/dashboard/dashboard_binding.dart';
import 'package:privatily_app/admin_launchcode/dashboard/dashboard_view.dart';
import 'package:privatily_app/modules/allProjects/allProjects.dart';
import 'package:privatily_app/modules/cart/cart_logic.dart';
import 'package:privatily_app/student_lanuchcode/screens/Home/home.dart';
import 'package:privatily_app/translation/app_translations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'admin_launchcode/home_page/logic.dart';
import 'admin_launchcode/home_page/view.dart';
import 'admin_launchcode/projects/newprojectscreen.dart';
import 'admin_launchcode/projects/projects.dart';
import 'admin_launchcode/screens/coursescreen.dart';
import 'admin_launchcode/screens/driver.dart';
import 'admin_launchcode/screens/home.dart';
import 'admin_launchcode/screens/reviews.dart';
import 'admin_launchcode/screens/setting.dart';
import 'admin_launchcode/screens/students_screen/students.dart';
import 'firebase_options.dart';
import 'firebase_utils.dart';
import 'modules/cart/cart_view.dart';
import 'modules/chat_page/chat/view/widgets/variables/globalVariables.dart';
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
    await setUserOnline(globalChatRoomId);
  }
  // Register controllers before runApp
  Get.put(ProductsController());
  Get.put(CartLogic());

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
        theme: ThemeData(
          fontFamily: Get.locale?.languageCode == 'ur' ? 'JameelNoori' : null,
          textTheme: ThemeData.light().textTheme.apply(
            fontFamily: Get.locale?.languageCode == 'ur' ? 'JameelNoori' : null,
          ),
          focusColor: Colors.transparent,
        ),
        getPages: [
          GetPage(name: '/', page: () => const Home()),
          GetPage(name: CartPage.routeName, page: () => const CartPage()),
          GetPage(name: CheckoutPage.routeName, page: () => const CheckoutPage()),
          GetPage(name: AllProducts.routeName, page: () => const AllProducts()),
          GetPage(name: '/HomePage', page: () => const HomePage()),
          GetPage(
            name: '/product-detail/:projectId',
            page: () => ProjectDetailsPage(),
          ),
          GetPage(
            name: "/Admindashboard",
            page: () => AdminDashboardPage(),
            binding: BindingsBuilder(() {
              Get.put(LogicadminHome()); // ✅ Make sure HomeLogic is available
            }),
          ),
          GetPage(
            name: '/home',
            page: () => HomeScreen(),
          ),
          GetPage(
            name: '/projects',
            page: () => ProjectScreen(),
          ),
          GetPage(
            name: "/course",
            page: () => CourseScreen(),
          ),
          GetPage(
            name: '/reviews',
            page: () => ReviewsScreen(),
          ),

          /// ✅ Dynamically get IDs from HomeLogic for ChattingPage
          GetPage(
            name: '/chats',
            page: () {
              // final homeLogic = Get.find<HomeLogic>();
              return AdminChatHome();
            },
          ),

          GetPage(
            name: '/students',
            page: () => StudentsScreen(),
          ),
          GetPage(
            name: '/driver',
            page: () => DriverScreen(),
          ),
          GetPage(
            name: '/settings',
            page: () => SettingsScreen(),
          ),
          GetPage(
            name: '/addNew',
            page: () => AddProjectScreen(),
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
        initialBinding:AppBinding(),
        // Remove `home` when using initialRoute
        // home: const Home(),
      ),
    );
  }
}
