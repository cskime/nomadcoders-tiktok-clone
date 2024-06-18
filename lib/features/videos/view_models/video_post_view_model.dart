import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _videosRepository;
  late final User _user;
  late final String _videoId;

  @override
  FutureOr<void> build(String arg) {
    _videosRepository = ref.read(videosRepository);
    _user = ref.read(authenticationRepository).user!;
    _videoId = arg;
  }

  Future<void> toggleLikeVideo() async => await _videosRepository
      .toggleLikeVideo(videoId: _videoId, userId: _user.uid);

  Future<bool> fetchIsLikedVideo() async =>
      _videosRepository.fetchIsLikedVideo(videoId: _videoId, userId: _user.uid);
}
