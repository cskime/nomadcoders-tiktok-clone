import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _videosRepository;

  @override
  FutureOr<void> build() {
    _videosRepository = ref.read(videosRepository);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authenticationRepository).user;
    final userProfile = ref.read(usersProvider).value;

    if (user == null || userProfile == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final task = await _videosRepository.uploadVideoFile(
          video,
          user.uid,
        );

        if (task.metadata != null) {
          final videoModel = VideoModel(
            title: "Video title",
            description: "Video description",
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailUrl: "",
            creatorUid: user.uid,
            creator: userProfile.name,
            likeCount: 0,
            commentCount: 0,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          );

          await _videosRepository.saveVideo(videoModel);
        }
      },
    );

    if (!context.mounted) {
      return;
    }

    context.pushReplacement("/home");
  }
}
