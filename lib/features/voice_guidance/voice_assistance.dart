import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:tech_pirates/features/translate/translation.dart';

class VoiceAssistance {
  static Future<void> speak(String text, String lang) async {
    TranslateLanguage? target;

    switch (lang) {
      case "en-US":
        target = TranslateLanguage.english;
        break;
      case "kn-IN":
        target = TranslateLanguage.kannada;
        break;
      case "hi-IN":
        target = TranslateLanguage.hindi;
        break;

      default:
        target = TranslateLanguage.english;
    }

    Translation ob = Translation(
        sourceLanguage: TranslateLanguage.english, targetLanguage: target);
    var hello = await ob.translateText(text);
    String some = hello.toString();

    FlutterTts flutterTts = FlutterTts();
    if (some.isNotEmpty) {
      await flutterTts.setLanguage(lang);

      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(some);
    }
  }
}
