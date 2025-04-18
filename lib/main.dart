import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; // ✅ Needed for Material localization
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:privatily_app/sections/featuredProducts/productController.dart';
import 'package:privatily_app/translation/app_translations.dart';

import 'firebase_options.dart';
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

      // ✅ FIXED: Provide MaterialLocalizations
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('ar', 'AR'),
      ],

      // ✅ Home screen
      home: const Home(),
    );
  }
}
