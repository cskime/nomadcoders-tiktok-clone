import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _videosRepository;

  @override
  FutureOr<void> build() {
    _videosRepository = ref.read(videosRepository);
  }

  Future<void> uploadVideo(File video) async {
    final user = ref.read(authenticationRepository).user;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final task = await _videosRepository.uploadVideoFile(
          video,
          user!.uid,
        );

        if (task.metadata != null) {
          await _videosRepository.saveVideo();
        }
      },
    );
  }
}
