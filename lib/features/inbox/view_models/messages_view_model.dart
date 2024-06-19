import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repositories/messages_repository.dart';

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider<List<Message>>((ref) {
  final database = FirebaseFirestore.instance;
  return database
      .collection("chat_roomos")
      .doc("JgM17lyY08VRZ8W4xC8g")
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((document) => Message.fromJson(
                  document.data(),
                ))
            .toList(),
      );
});

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepository _messagesRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _messagesRepository = ref.read(messagesRepository);
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
