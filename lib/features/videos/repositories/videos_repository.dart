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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos() async {
    return await _database
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .get();
  }
}
