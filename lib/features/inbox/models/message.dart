class Message {
  Message({
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  final String text;
  final String userId;
  final int createdAt;

  Message.fromJson(Map<String, dynamic> json)
      : text = json["text"],
        userId = json["userId"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() => {
        "text": text,
        "userId": userId,
        "createdAt": createdAt,
      };
}
