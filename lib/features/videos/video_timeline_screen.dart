import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  final _pageController = PageController();
  int _itemCount = 4;

  final colors = [
    Colors.blue,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
  ];

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
    );
    setState(() {
      if (page == _itemCount - 1) {
        _itemCount = _itemCount + 4;
        colors.addAll([
          Colors.blue,
          Colors.teal,
          Colors.yellow,
          Colors.pink,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: _itemCount,
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
          child: Text(
            'Screen $index',
            style: const TextStyle(
              fontSize: 60,
            ),
          ),
        ),
      ),
    );
  }
}
