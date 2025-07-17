// lib/providers/language_provider.dart
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _languageCode = 'vi';

  String get languageCode => _languageCode;

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }
}
