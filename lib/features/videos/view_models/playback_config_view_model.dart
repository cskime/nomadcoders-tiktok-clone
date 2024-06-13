import 'package:flutter/widgets.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repositories/video_playback_config_repository.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  PlaybackConfigViewModel(this._repository);

  final VideoPlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.muted(),
    autoplay: _repository.autoplay(),
  );

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;
}
