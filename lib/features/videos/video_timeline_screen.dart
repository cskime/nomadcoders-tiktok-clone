import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  final _pageController = PageController();
  final duration = const Duration(milliseconds: 250);
  final curve = Curves.linear;

  int _itemCount = 4;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: duration,
      curve: curve,
    );
    setState(() {
      if (page == _itemCount - 1) {
        _itemCount = _itemCount + 4;
      }
    });
  }

  void _onVideoFinished() {
    _pageController.nextPage(duration: duration, curve: curve);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: _itemCount,
      itemBuilder: (context, index) => VideoPost(
        onVideoFinished: _onVideoFinished,
      ),
    );
  }
}
