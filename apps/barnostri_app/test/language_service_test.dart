import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageService', () {
    test('initialize loads saved locale', () async {
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en_GB',
      });
      final service = LanguageService();
      await service.initialize();
      expect(service.state, const Locale('en', 'GB'));
    });

    test('initialize defaults to defaultLocale', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LanguageService();
      await service.initialize();
      expect(service.state, LanguageService.defaultLocale);
    });

    test('changeLanguage saves to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LanguageService();
      await service.initialize();
      await service.changeLanguage(const Locale('fr', 'CH'));
      expect(service.state, const Locale('fr', 'CH'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_language'), 'fr_CH');
    });

    test('changeLanguage throws for unsupported locale', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LanguageService();
      await service.initialize();
      expect(
        () => service.changeLanguage(const Locale('es', 'ES')),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
