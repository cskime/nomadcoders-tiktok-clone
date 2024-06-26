import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.videoIndex,
    required this.videoData,
  });

  final void Function() onVideoFinished;
  final int videoIndex;
  final VideoModel videoData;

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  final _videoPlayerController =
      VideoPlayerController.asset('assets/videos/video.mp4');

  bool _isPaused = false;
  bool _isLiked = false;
  int _likeCount = 0;

  final _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  void _setMute(bool mute) async {
    await _videoPlayerController.setVolume(mute ? 0 : 1);
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _initLike();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;

    if (ref.read(playbackConfigViewModel).muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  void _initLike() async {
    _likeCount = widget.videoData.likeCount;
    _isLiked = await ref
        .read(videoPostProvider(widget.videoData.id).notifier)
        .fetchIsLikedVideo();
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    if (kIsWeb) {
      _setMute(true);
    }
    setState(() {
      _videoPlayerController.play();
    });
    _videoPlayerController.addListener(_onVideoChange);
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // Widget이 dispose된 이후 `VideoPlayerController`가 사용되는 경우를 방지하기 위해
    // 화면에 변화가 있더라도 widget이 unmounted 되었다면 video controller 실행을 막음
    // Unmounted == widget이 widget tree에서 삭제됨
    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigViewModel).autoplay) {
        _videoPlayerController.play();
      } else {
        _videoPlayerController.pause();
      }
    }

    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap() async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }

    await showModalBottomSheet(
      context: context,
      builder: (context) => const VideoComments(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );

    _onTogglePause();
  }

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.id).notifier).toggleLikeVideo();
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.videoIndex}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(color: Colors.black),
          ),
          Positioned.fill(
            child: GestureDetector(onTap: _onTogglePause),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${widget.videoData.creator}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v14,
                Text(
                  widget.videoData.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 20,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/tiktok-cskim.appspot.com/o/avatars%2F${widget.videoData.creatorUid}?alt=media",
                  ),
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v20,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  color: _isLiked ? Colors.red : Colors.white,
                  title: S.of(context).likeCount(_likeCount),
                  onPressed: _onLikeTap,
                ),
                Gaps.v20,
                GestureDetector(
                  onTap: _onCommentsTap,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    title: S
                        .of(context)
                        .commentCount(widget.videoData.commentCount),
                  ),
                ),
                Gaps.v20,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  title: 'Share',
                ),
              ],
            ),
          ),
          Positioned(
            top: Sizes.size40,
            left: Sizes.size24,
            child: IconButton(
              icon: FaIcon(
                ref.watch(playbackConfigViewModel).muted
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _onPlaybackConfigChanged,
            ),
          ),
        ],
      ),
    );
  }
}
