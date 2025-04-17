import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
      translations: AppTranslations(), // custom class
      locale: const Locale('en', 'US'), // default locale
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('es', 'ES'),
        Locale('ar', 'AR'),
      ],
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      debugShowCheckedModeBanner: false,
      title: 'LaunchCode',
      home: const Home(),
    );
  }
}
