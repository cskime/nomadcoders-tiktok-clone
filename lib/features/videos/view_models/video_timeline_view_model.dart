import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

final videoTimelineViewModel =
    AsyncNotifierProvider<VideoTimelineViewModel, List<VideoModel>>(
  () => VideoTimelineViewModel(),
);

class VideoTimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _videosRepository;
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    _videosRepository = ref.read(videosRepository);
    final result = await _videosRepository.fetchVideos();
    _list = result.docs
        .map((document) => VideoModel.fromJson(document.data()))
        .toList();
    return _list;
  }
}
