import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat.dart';
import 'package:tiktok_clone/features/inbox/repositories/chats_repository.dart';

final chatsViewModelProvider =
    AsyncNotifierProvider.autoDispose<ChatsViewModel, List<Chat>>(
  () => ChatsViewModel(),
);

class ChatsViewModel extends AutoDisposeAsyncNotifier<List<Chat>> {
  late final AuthenticationRepository _authenticationRepository;
  late final ChatsRepository _chatsRepository;
  late final myUser = _authenticationRepository.user!;

  List<Chat> _chats = [];

  @override
  FutureOr<List<Chat>> build() async {
    _authenticationRepository = ref.read(authenticationRepository);
    _chatsRepository = ref.read(chatsRepository);

    final chats = await _chatsRepository.fetchChats(myUser.uid);
    _chats = chats.map((chat) => Chat.fromJson(chat)).toList();
    return _chats;
  }

  Future<void> createChat(Chat newChat) async {
    await _chatsRepository.createChat(newChat.toJson());
    _chats.add(newChat);
    state = AsyncValue.data(_chats);
  }

  String otherUserNameFromChat(Chat chat) {
    return chat.user1Id == myUser.uid ? chat.user2Name : chat.user1Name;
  }
}
