import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoButton extends StatelessWidget {
  const VideoButton({
    super.key,
    required this.icon,
    this.color = Colors.white,
    required this.title,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: color,
            size: Sizes.size24,
          ),
          Gaps.v4,
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
