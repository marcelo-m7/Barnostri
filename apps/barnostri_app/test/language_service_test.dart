import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';

class FailingStore extends InMemorySharedPreferencesStore {
  FailingStore() : super.empty();

  @override
  Future<Map<String, Object>> getAll() =>
      Future<Map<String, Object>>.error(Exception('getAll failed'));

  @override
  Future<bool> setValue(String valueType, String key, Object value) =>
      Future<bool>.error(Exception('setValue failed'));
}

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

    test('isLocaleSupported checks supported locales', () {
      final service = LanguageService();
      expect(service.isLocaleSupported(const Locale('pt', 'BR')), isTrue);
      expect(service.isLocaleSupported(const Locale('en', 'GB')), isTrue);
      expect(service.isLocaleSupported(const Locale('fr', 'CH')), isTrue);
      expect(service.isLocaleSupported(const Locale('es', 'ES')), isFalse);
    });

    test('getBestMatchingLocale picks best match from device locales', () {
      final service = LanguageService();
      final result = service.getBestMatchingLocale([
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('en', 'US'),
      ]);
      expect(result, const Locale('fr', 'CH'));
    });

    test('getBestMatchingLocale falls back to defaultLocale', () {
      final service = LanguageService();
      final result = service.getBestMatchingLocale([
        const Locale('es', 'ES'),
        const Locale('de', 'DE'),
      ]);
      expect(result, LanguageService.defaultLocale);
    });

    test('initialize logs error when SharedPreferences fails', () async {
      SharedPreferences.resetStatic();
      SharedPreferencesStorePlatform.instance = FailingStore();
      final logs = <String>[];
      final original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      final service = LanguageService();
      await service.initialize();

      debugPrint = original;
      expect(logs.any((l) => l.contains('Erro')), isTrue);
    });

    test('changeLanguage logs error when saving fails', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LanguageService();
      await service.initialize();

      SharedPreferences.resetStatic();
      SharedPreferencesStorePlatform.instance = FailingStore();
      final logs = <String>[];
      final original = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      await service.changeLanguage(const Locale('en', 'GB'));

      debugPrint = original;
      expect(logs.any((l) => l.contains('Erro')), isTrue);
    });
  });
}
