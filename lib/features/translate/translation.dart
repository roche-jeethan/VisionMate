import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class Translation {
  Translation({
    required this.sourceLanguage,
    required this.targetLanguage,
  }) {
    _initTranslator();
  }

  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  late OnDeviceTranslator onDeviceTranslator;

  void _initTranslator() {
    onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  Future<String> translateText(String sourceText) async {
    final String translation =
        await onDeviceTranslator.translateText(sourceText);
    return translation;
  }

  void dispose() {
    onDeviceTranslator.close();
  }
}
