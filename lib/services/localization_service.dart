import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static LocalizationService? _instance;

  LocalizationService._internal();

  factory LocalizationService() {
    _instance ??= LocalizationService._internal();
    return _instance!;
  }

  Locale _currentLocale = const Locale('ru');

  Locale get currentLocale => _currentLocale;

  final List<Locale> supportedLocales = const [
    Locale('ru'),
    Locale('en'),
    Locale('ar'),
  ];

  Map<String, String> get languageNames => {
        'ru': 'Русский',
        'en': 'English',
        'ar': 'العربية',
      };

  Map<String, String> get languageFlags => {
        'ru': '🇷🇺',
        'en': '🇺🇸',
        'ar': '🇸🇦',
      };

  Future<void> initializeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode);

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      notifyListeners();
    }
  }

  String getCurrentLanguageName() {
    return languageNames[_currentLocale.languageCode] ?? 'Unknown';
  }

  String getCurrentLanguageFlag() {
    return languageFlags[_currentLocale.languageCode] ?? '🌐';
  }

  bool isRTL() {
    return _currentLocale.languageCode == 'ar';
  }
}
