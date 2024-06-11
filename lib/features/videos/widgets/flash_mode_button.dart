import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashModeButton extends StatelessWidget {
  const FlashModeButton({
    super.key,
    required this.flashMode,
    required this.selected,
    required this.onPressed,
  });

  final FlashMode flashMode;
  final bool selected;
  final void Function(FlashMode flashMode) onPressed;

  IconData get _iconData => switch (flashMode) {
        FlashMode.off => Icons.flash_off_rounded,
        FlashMode.always => Icons.flash_on_rounded,
        FlashMode.auto => Icons.flash_auto_rounded,
        FlashMode.torch => Icons.flashlight_on_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_iconData),
      color: selected ? Colors.amber.shade200 : Colors.white,
      onPressed: () => onPressed(flashMode),
    );
  }
}
