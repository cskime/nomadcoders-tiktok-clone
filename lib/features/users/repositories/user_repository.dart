import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfileModel userProfile) async {
    await _database
        .collection("users")
        .doc(userProfile.uid)
        .set(userProfile.toJson());
  }
  // getProfile() {}
  // updateProfile() {}
}

final userRepository = Provider(
  (ref) => UserRepository(),
);
