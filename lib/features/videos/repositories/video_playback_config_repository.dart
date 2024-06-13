import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  VideoPlaybackConfigRepository(this._preferences);

  static const _autoplayKey = 'autoplay';
  static const _mutedKey = 'muted';

  final SharedPreferences _preferences;

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_mutedKey, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplayKey, value);
  }

  bool muted() {
    return _preferences.getBool(_mutedKey) ?? false;
  }

  bool autoplay() {
    return _preferences.getBool(_autoplayKey) ?? false;
  }
}
