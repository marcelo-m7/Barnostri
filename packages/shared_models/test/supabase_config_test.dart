import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  test('isConfigured is false before initialization', () {
    expect(SupabaseConfig.isConfigured, isFalse);
  });
}
