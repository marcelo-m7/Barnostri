import 'package:shared_models/shared_models.dart';

abstract class ProfileRepository {
  Future<void> createProfile(UserProfile profile);
  Future<UserProfile?> fetchProfile(String id);
}
