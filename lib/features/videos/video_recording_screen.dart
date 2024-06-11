import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_mode_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _isSelfieMode = false;

  late FlashMode _flashMode;

  late CameraController _cameraController;

  late final _buttonAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final Animation<double> _recordButtonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final _progressAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.low,
    );

    await _cameraController.initialize();

    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (_cameraController.value.isRecordingVideo) {
      return;
    }

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return;
    }

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPermissions();

    _progressAnimationController.addListener(() => setState(() {}));
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future<void> _onpickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: !_hasPermission || !_cameraController.value.isInitialized
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Initializing...",
                    style:
                        TextStyle(color: Colors.white, fontSize: Sizes.size20),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive()
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size64,
                    right: Sizes.size16,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cameraswitch),
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                        ),
                        FlashModeButton(
                          flashMode: FlashMode.off,
                          selected: _flashMode == FlashMode.off,
                          onPressed: _setFlashMode,
                        ),
                        FlashModeButton(
                          flashMode: FlashMode.always,
                          selected: _flashMode == FlashMode.always,
                          onPressed: _setFlashMode,
                        ),
                        FlashModeButton(
                          flashMode: FlashMode.auto,
                          selected: _flashMode == FlashMode.auto,
                          onPressed: _setFlashMode,
                        ),
                        FlashModeButton(
                          flashMode: FlashMode.torch,
                          selected: _flashMode == FlashMode.torch,
                          onPressed: _setFlashMode,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Sizes.size40,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTapDown: (_) => _startRecording(),
                          onTapUp: (_) => _stopRecording(),
                          onLongPressUp: () => _stopRecording(),
                          child: ScaleTransition(
                            scale: _recordButtonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size10,
                                  height: Sizes.size80 + Sizes.size10,
                                  child: CircularProgressIndicator(
                                    value: _progressAnimationController.value,
                                    color: Colors.red.shade500,
                                    strokeWidth: Sizes.size4,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onpickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.images,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
