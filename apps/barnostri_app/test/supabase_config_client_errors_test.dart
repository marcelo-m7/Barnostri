import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barnostri_app/src/core/services/supabase_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = 'flutter/assets';

  setUp(() {
    // Ensure a clean state before each test.
    rootBundle.clear();
  });

  tearDown(() async {
    // Remove any mock handlers and dispose the Supabase instance.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(channel, null);
    rootBundle.clear();
    try {
      await Supabase.instance.dispose();
    } catch (_) {}
  });

  group('SupabaseConfig.createClient error handling', () {
    test('missing asset throws Exception with expected message', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channel, (ByteData? message) async => null);

      await expectLater(
        () => SupabaseConfig.createClient(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(
              'Unable to load supabase-config.json: Unable to load asset: "supabase/supabase-config.json"',
            ),
          ),
        ),
      );
    });

    test('invalid JSON or missing keys throws FormatException', () async {
      final invalid = jsonEncode({
        'dev': {
          'SUPABASE_URL': 'https://example.com'
          // Missing SUPABASE_ANON_KEY
        }
      });
      final data = Uint8List.fromList(utf8.encode(invalid));

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(channel, (ByteData? message) async {
        final received = utf8.decode(message!.buffer.asUint8List());
        if (received == 'supabase/supabase-config.json') {
          return ByteData.view(data.buffer);
        }
        return null;
      });

      await expectLater(
        () => SupabaseConfig.createClient(),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
