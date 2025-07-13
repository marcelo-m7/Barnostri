import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = SupabaseProfileRepository(null);

  group('SupabaseProfileRepository mock', () {
    test('createProfile completes', () async {
      final profile = UserProfile(
        id: 'u1',
        name: 'User',
        phone: '123',
        userType: UserType.cliente,
        storeName: null,
        createdAt: DateTime.now(),
      );
      await repo.createProfile(profile);
    });

    test('fetchProfile returns mock profile', () async {
      final profile = await repo.fetchProfile('u1');
      expect(profile?.id, 'u1');
      expect(profile?.userType, UserType.cliente);
    });
  });
}
