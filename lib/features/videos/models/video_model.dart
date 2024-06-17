class VideoModel {
  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
  });

  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final int likeCount;
  final int commentCount;
  final int createdAt;
}
