import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _videosRepository;
  late final String _videoId;

  @override
  FutureOr<void> build(String arg) {
    _videosRepository = ref.read(videosRepository);
    _videoId = arg;
  }

  Future<void> likeVideo() async {
    final user = ref.read(authenticationRepository).user;
    await _videosRepository.likeVideo(_videoId, user!.uid);
  }
}
