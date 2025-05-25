import 'package:get/get.dart';
import 'package:privatily_app/translation/ur_PK.dart';
import 'en_US.dart';
import 'es_ES.dart';
import 'fr_FR.dart';
import 'ar_AR.dart';

class AppTranslations extends Translations {



  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'es_ES': esES,
    'fr_FR': frFR,
    'ar_AR': arAR,
    'ur': urPK
  };
}
