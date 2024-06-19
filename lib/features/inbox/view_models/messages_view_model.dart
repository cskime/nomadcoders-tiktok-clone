import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repositories/messages_repository.dart';

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

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
      );
      _messagesRepository.sendMessage(message);
    });
  }
}
