class VideoModel {
  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.creator,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final int likeCount;
  final int commentCount;
  final int createdAt;

  VideoModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : id = videoId,
        title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        likeCount = json["likeCount"],
        commentCount = json["commentCount"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "likeCount": likeCount,
      "commentCount": commentCount,
      "createdAt": createdAt,
    };
  }
}
