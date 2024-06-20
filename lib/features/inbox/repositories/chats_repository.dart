import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatsRepository = Provider<ChatsRepository>((ref) => ChatsRepository());

class ChatsRepository {
  final _storage = FirebaseFirestore.instance;
  late final _collection = _storage.collection("chat_rooms");

  Future<String> createChat(Map<String, dynamic> data) async {
    final document = await _collection.add(data);
    return document.id;
  }

  Future<List<Map<String, dynamic>>> fetchChats(String uid) async {
    var snapshot = await _collection.where("user1Id", isEqualTo: uid).get();

    if (snapshot.docs.isEmpty) {
      snapshot = await _collection.where("user2Id", isEqualTo: uid).get();
    }

    return snapshot.docs
        .map((document) => {...document.data(), "id": document.id})
        .toList();
  }
}
