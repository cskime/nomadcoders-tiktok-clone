class Message {
  Message({
    required this.text,
    required this.userId,
  });

  final String text;
  final String userId;

  Message.fromJson(Map<String, dynamic> json)
      : text = json["text"],
        userId = json["userId"];

  Map<String, dynamic> toJson() => {
        "text": text,
        "userId": userId,
      };
}
