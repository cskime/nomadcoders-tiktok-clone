import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repositories/video_playback_config_repository.dart';

final playbackConfigViewModel =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  PlaybackConfigViewModel(this._repository);

  final VideoPlaybackConfigRepository _repository;

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.muted(),
      autoplay: _repository.autoplay(),
    );
  }
}
