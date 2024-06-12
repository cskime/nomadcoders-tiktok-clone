import 'package:flutter/widgets.dart';

class VideoConfig extends StatefulWidget {
  const VideoConfig({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<VideoConfig> createState() => VideoConfigState();
}

class VideoConfigState extends State<VideoConfig> {
  bool _autoMute = false;

  void _toggleMuted() {
    setState(() {
      _autoMute = !_autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      autoMute: _autoMute,
      toggleMuted: _toggleMuted,
      child: widget.child,
    );
  }
}

class VideoConfigData extends InheritedWidget {
  const VideoConfigData({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  });

  final bool autoMute;
  final void Function() toggleMuted;

  static VideoConfigData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
