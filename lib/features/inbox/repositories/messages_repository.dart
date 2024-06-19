import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

final messagesRepository = Provider((ref) => MessagesRepository());

class MessagesRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<void> sendMessage(Message message) async {
    await _database
        .collection("chat_rooms")
        .doc("JgM17lyY08VRZ8W4xC8g")
        .collection("texts")
        .add(message.toJson());
  }
}
