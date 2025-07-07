import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('en', 'GB'), // English (UK)
    Locale('fr', 'CH'), // French (Switzerland)
  ];
  
  // Default locale
  static const Locale defaultLocale = Locale('pt', 'BR');
  
  Locale _currentLocale = defaultLocale;
  
  Locale get currentLocale => _currentLocale;
  
  /// Initialize the language service and load saved language preference
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      
      if (savedLanguage != null) {
        final parts = savedLanguage.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          if (supportedLocales.contains(locale)) {
            _currentLocale = locale;
          }
        }
      }
    } catch (e) {
      print('Error loading language preference: $e');
      _currentLocale = defaultLocale;
    }
    notifyListeners();
  }
  
  /// Change the current language
  Future<void> changeLanguage(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }
    
    _currentLocale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, '${locale.languageCode}_${locale.countryCode}');
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }
  
  /// Get language display name
  String getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
  
  /// Get country flag emoji
  String getCountryFlag(Locale locale) {
    switch (locale.countryCode) {
      case 'BR':
        return '🇧🇷';
      case 'GB':
        return '🇬🇧';
      case 'CH':
        return '🇨🇭';
      default:
        return '🌍';
    }
  }
  
  /// Check if a locale is supported
  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) => 
      supportedLocale.languageCode == locale.languageCode &&
      supportedLocale.countryCode == locale.countryCode
    );
  }
  
  /// Get the best matching locale from device locales
  Locale getBestMatchingLocale(List<Locale> deviceLocales) {
    for (final deviceLocale in deviceLocales) {
      // First try exact match
      if (isLocaleSupported(deviceLocale)) {
        return deviceLocale;
      }
      
      // Then try language code match
      final matchingLocale = supportedLocales.firstWhere(
        (supportedLocale) => supportedLocale.languageCode == deviceLocale.languageCode,
        orElse: () => defaultLocale,
      );
      
      if (matchingLocale != defaultLocale) {
        return matchingLocale;
      }
    }
    
    return defaultLocale;
  }
}