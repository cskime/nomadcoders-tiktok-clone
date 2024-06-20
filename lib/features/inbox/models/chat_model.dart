import 'package:tiktok_clone/features/inbox/models/chat.dart';

class ChatModel {
  ChatModel({
    required this.chatId,
    required this.chat,
  });

  final String chatId;
  final Chat chat;

  ChatModel.fromJson(Map<String, dynamic> json)
      : chatId = json["id"],
        chat = Chat.fromJson(json);

  Map<String, dynamic> toJson() => {"id": chatId, ...chat.toJson()};
}
