import 'dart:ui';

import 'package:get/get.dart';

class TranslationController extends GetxController {
  final language = 'en'.obs;

  void changeLanguage(String lang) {
    language.value = lang;
    Get.updateLocale(Locale(lang));
  }
}
