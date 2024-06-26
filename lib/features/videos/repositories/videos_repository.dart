import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

final videosRepository = Provider(
  (ref) => VideosRepository(),
);

class VideosRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileReference = _storage
        .ref()
        .child("/videos/$uid/${DateTime.now().millisecondsSinceEpoch}");
    return fileReference.putFile(video);
  }

  Future<void> saveVideo(VideoModel videoModel) async {
    await _database.collection("videos").add(videoModel.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final query = _database
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);

    if (lastItemCreatedAt == null) {
      return query.get();
    }

    return query.startAfter([lastItemCreatedAt]).get();
  }

  DocumentReference<Map<String, dynamic>> _fetchLike({
    required String videoId,
    required String userId,
  }) =>
      _database.collection("likes").doc("$videoId-$userId");

  Future<void> toggleLikeVideo({
    required String videoId,
    required String userId,
  }) async {
    final query = _fetchLike(videoId: videoId, userId: userId);
    final like = await query.get();
    if (!like.exists) {
      await query.set({"createdAt": DateTime.now().millisecondsSinceEpoch});
    } else {
      await query.delete();
    }
  }

  Future<bool> fetchIsLikedVideo({
    required String videoId,
    required String userId,
  }) async {
    final like = await _fetchLike(videoId: videoId, userId: userId).get();
    return like.exists;
  }
}
