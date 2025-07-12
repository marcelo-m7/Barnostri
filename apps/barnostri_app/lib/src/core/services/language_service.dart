import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LanguageService extends StateNotifier<Locale> {
  LanguageService() : super(defaultLocale);

  static const String _languageKey = 'selected_language';

  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'GB'),
    Locale('fr', 'CH'),
  ];

  static const Locale defaultLocale = Locale('pt', 'BR');

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null) {
        final parts = savedLanguage.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          if (supportedLocales.contains(locale)) {
            state = locale;
            return;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erro ao carregar idioma salvo: $e');
      }
    }
    state = defaultLocale;
  }

  Future<void> changeLanguage(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _languageKey,
        '${locale.languageCode}_${locale.countryCode}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erro ao salvar idioma: $e');
      }
    }
  }

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

  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supported) =>
          supported.languageCode == locale.languageCode &&
          supported.countryCode == locale.countryCode,
    );
  }

  Locale getBestMatchingLocale(List<Locale> deviceLocales) {
    for (final deviceLocale in deviceLocales) {
      if (isLocaleSupported(deviceLocale)) return deviceLocale;
      final match = supportedLocales.firstWhere(
        (supported) => supported.languageCode == deviceLocale.languageCode,
        orElse: () => defaultLocale,
      );
      if (match != defaultLocale) return match;
    }
    return defaultLocale;
  }
}

final languageServiceProvider = StateNotifierProvider<LanguageService, Locale>(
  (ref) => LanguageService(),
);
