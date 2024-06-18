import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/video_timeline_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final _pageController = PageController();
  final duration = const Duration(milliseconds: 250);
  final curve = Curves.linear;

  int _itemCount = 0;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: duration,
      curve: curve,
    );

    if (page == _itemCount - 1) {
      ref.read(videoTimelineViewModel.notifier).fetchNextPage();
    }
  }

  void _onVideoFinished() {
    return;
    // _pageController.nextPage(duration: duration, curve: curve);
  }

  @override
  void dispose() {
    _pageController.dispose();
    ref.invalidate(videoTimelineViewModel);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    return Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(videoTimelineViewModel).when(
          data: (videos) {
            _itemCount = videos.length;
            return RefreshIndicator(
              displacement: 50,
              edgeOffset: 20,
              backgroundColor: Colors.black,
              color: Theme.of(context).primaryColor,
              strokeWidth: 4,
              onRefresh: _onRefresh,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return VideoPost(
                    onVideoFinished: _onVideoFinished,
                    videoIndex: index,
                    videoData: videoData,
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load videos: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
