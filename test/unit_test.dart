import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

void main() {
  group("VideoModel test", () {
    test("Constructor test", () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        likeCount: 1,
        commentCount: 1,
        createdAt: 1,
      );
      expect(video.id, 'id');
    });

    test(".fromJson constructor test", () {
      final video = VideoModel.fromJson(
        json: {
          "title": "title",
          "description": "description",
          "fileUrl": "fileUrl",
          "thumbnailUrl": "thumbnailUrl",
          "creatorUid": "creatorUid",
          "creator": "creator",
          "likeCount": 1,
          "commentCount": 1,
          "createdAt": 1,
        },
        videoId: "id",
      );
      expect(video.title, equals("title"));
      expect(video.commentCount, greaterThan(0));
    });

    test("toJson() method test", () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        likeCount: 1,
        commentCount: 1,
        createdAt: 1,
      );
      final json = video.toJson();
      expect(json["id"], video.id);
      expect(json["likeCount"], isInstanceOf<int>());
    });
  });
}
