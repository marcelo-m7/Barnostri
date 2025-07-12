import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barnostri_app/src/core/services/supabase_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = 'flutter/assets';
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(channel, null);
    rootBundle.clear();
    try {
      await Supabase.instance.dispose();
    } catch (_) {}
  });

  group('SupabaseConfig.createClient', () {
    test('loads JSON from supabase/supabase-config.json', () async {
      final config = jsonEncode({
        'dev': {
          'SUPABASE_URL': 'https://example.com',
          'SUPABASE_ANON_KEY': 'KEY',
        }
      });
      final data = Uint8List.fromList(utf8.encode(config));

      String? received;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        channel,
        (ByteData? message) async {
          received = utf8.decode(message!.buffer.asUint8List());
          if (received == 'supabase/supabase-config.json') {
            return ByteData.view(data.buffer);
          }
          return null;
        },
      );

      final client = await SupabaseConfig.createClient();
      expect(received, 'supabase/supabase-config.json');
      expect(client, isA<SupabaseClient>());
    });

    test('throws when asset path is wrong', () async {
      final config = jsonEncode({
        'dev': {
          'SUPABASE_URL': 'https://example.com',
          'SUPABASE_ANON_KEY': 'KEY',
        }
      });
      final data = Uint8List.fromList(utf8.encode(config));

      String? received;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        channel,
        (ByteData? message) async {
          received = utf8.decode(message!.buffer.asUint8List());
          if (received == 'wrong/path.json') {
            return ByteData.view(data.buffer);
          }
          return null;
        },
      );

      expect(
        () => SupabaseConfig.createClient(),
        throwsA(predicate((e) {
          return e.toString().contains('supabase-config.json');
        })),
      );
      expect(received, 'supabase/supabase-config.json');
    });

    test('throws when JSON is malformed', () async {
      const invalidJson = '{invalid';
      final data = Uint8List.fromList(utf8.encode(invalidJson));

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        channel,
        (ByteData? message) async {
          final received = utf8.decode(message!.buffer.asUint8List());
          if (received == 'supabase/supabase-config.json') {
            return ByteData.view(data.buffer);
          }
          return null;
        },
      );

      await expectLater(
        () => SupabaseConfig.createClient(),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Malformed Supabase configuration'),
          ),
        ),
      );
    });

    test('returns existing client when already configured', () async {
      final config = jsonEncode({
        'dev': {
          'SUPABASE_URL': 'https://example.com',
          'SUPABASE_ANON_KEY': 'KEY',
        }
      });
      final data = Uint8List.fromList(utf8.encode(config));

      var loadCount = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
        channel,
        (ByteData? message) async {
          final received = utf8.decode(message!.buffer.asUint8List());
          if (received == 'supabase/supabase-config.json') {
            loadCount++;
            return ByteData.view(data.buffer);
          }
          return null;
        },
      );

      final first = await SupabaseConfig.createClient();
      expect(first, isA<SupabaseClient>());
      expect(loadCount, 1);

      rootBundle.clear();

      final second = await SupabaseConfig.createClient();
      expect(identical(first, second), isTrue);
      expect(loadCount, 1);
    });
  });
}
