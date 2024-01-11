import 'package:flutter/material.dart';

class LanguageService {
  static Locale currentLocale = Locale('en');

  static void updateLanguage(String languageCode) {
    switch (languageCode) {
      case 'es':
        currentLocale = Locale('es');
        break;
      case 'other':
        // Implement other languages
        break;
      default:
        currentLocale = Locale('en');
    }
    // Notify listeners about the language change
    // This might involve using a state management solution
  }
}
