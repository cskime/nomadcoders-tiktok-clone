import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

final userRepository = Provider(
  (ref) => UserRepository(),
);

class UserRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  late final _collection = _database.collection("users");

  Future<void> createProfile(UserProfileModel userProfile) async {
    await _database
        .collection("users")
        .doc(userProfile.uid)
        .set(userProfile.toJson());
  }

  Future<List<Map<String, dynamic>>> fetchProfiles() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((document) => document.data()).toList();
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _database.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileReference = _storage.ref().child("avatars/$fileName");
    await fileReference.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _database.collection("users").doc(uid).update(data);
  }
}
