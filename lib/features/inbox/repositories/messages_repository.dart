import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

final messagesRepository = Provider.family<MessagesRepository, String>(
  (ref, chatId) => MessagesRepository(chatId: chatId),
);

class MessagesRepository {
  MessagesRepository({required this.chatId});

  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final String chatId;

  Future<void> sendMessage(Message message) async {
    await _database
        .collection("chat_rooms")
        .doc(chatId)
        .collection("texts")
        .add(message.toJson());
  }
}
