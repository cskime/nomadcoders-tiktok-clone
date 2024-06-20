import 'package:tiktok_clone/features/inbox/models/message.dart';

class Chat {
  Chat({
    required this.user1Id,
    required this.user1Name,
    required this.user2Id,
    required this.user2Name,
    this.lastMessage,
  });

  final String user1Id;
  final String user1Name;
  final String user2Id;
  final String user2Name;
  final Message? lastMessage;

  Chat.fromJson(Map<String, dynamic> json)
      : user1Id = json["user1Id"],
        user1Name = json["user1Name"],
        user2Id = json["user2Id"],
        user2Name = json["user2Name"],
        lastMessage = json["lastMessage"] == null
            ? null
            : Message.fromJson(json["lastMessage"]);

  Map<String, dynamic> toJson() => {
        "user1Id": user1Id,
        "user1Name": user1Name,
        "user2Id": user2Id,
        "user2Name": user2Name,
        if (lastMessage != null) "lastMessage": lastMessage!.toJson(),
      };
}
