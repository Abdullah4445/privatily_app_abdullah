

import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _apiKey = 'AIzaSyAQN1LzZjiXNLMm13ebfOnhe8erzxiT5R8';

  static Future<String> translateText(String text, String targetLangCode) async {
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$_apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'target': targetLangCode,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Translation failed: ${response.body}');
    }
  }
}
