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

  Future<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result = await _videosRepository.fetchVideos();
    final videoModels = result.docs
        .map((document) => VideoModel.fromJson(document.data()))
        .toList();
    return videoModels;
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _videosRepository = ref.read(videosRepository);
    _list = await _fetchVideos();
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage = await _fetchVideos(
      lastItemCreatedAt: _list.last.createdAt,
    );
    state = AsyncValue.data([..._list, ...nextPage]);
  }
}
