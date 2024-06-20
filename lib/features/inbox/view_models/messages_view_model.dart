import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repositories/messages_repository.dart';

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String>(
  () => MessagesViewModel(),
);

final chatProvider =
    StreamProvider.family.autoDispose<List<Message>, String>((ref, chatId) {
  return FirebaseFirestore.instance
      .collection("chat_rooms")
      .doc(chatId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((document) => Message.fromJson(
                  document.data(),
                ))
            .toList()
            .reversed
            .toList(),
      );
});

class MessagesViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessagesRepository _messagesRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build(String arg) {
    _messagesRepository = ref.read(messagesRepository(arg));
    _authenticationRepository = ref.read(authenticationRepository);
  }

  Future<void> sendMessage(String text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = Message(
          text: text,
          userId: _authenticationRepository.user!.uid,
          createdAt: DateTime.now().millisecondsSinceEpoch);
      _messagesRepository.sendMessage(message);
    });
  }
}
