import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat.dart';
import 'package:tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/chats_repository.dart';

final chatsViewModelProvider =
    AsyncNotifierProvider.autoDispose<ChatsViewModel, List<ChatModel>>(
  () => ChatsViewModel(),
);

class ChatsViewModel extends AutoDisposeAsyncNotifier<List<ChatModel>> {
  late final AuthenticationRepository _authenticationRepository;
  late final ChatsRepository _chatsRepository;
  late final myUser = _authenticationRepository.user!;

  List<ChatModel> _chatModels = [];

  @override
  FutureOr<List<ChatModel>> build() async {
    _authenticationRepository = ref.read(authenticationRepository);
    _chatsRepository = ref.read(chatsRepository);

    final chats = await _chatsRepository.fetchChats(myUser.uid);
    _chatModels =
        chats.map((chatJson) => ChatModel.fromJson(chatJson)).toList();
    return _chatModels;
  }

  Future<ChatModel> createChat(Chat newChat) async {
    final chatId = await _chatsRepository.createChat(newChat.toJson());
    final newChatModel = ChatModel(chatId: chatId, chat: newChat);
    _chatModels.add(newChatModel);
    state = AsyncValue.data(_chatModels);
    return newChatModel;
  }

  String otherUserNameFromChat(Chat chat) {
    return chat.user1Id == myUser.uid ? chat.user2Name : chat.user1Name;
  }

  ChatModel chatAt(int index) {
    return _chatModels[index];
  }
}
