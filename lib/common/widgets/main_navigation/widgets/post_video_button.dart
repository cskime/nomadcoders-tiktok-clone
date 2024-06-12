import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatelessWidget {
  const PostVideoButton({
    super.key,
    required this.inverted,
  });

  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 20,
          child: Container(
            height: 30,
            width: 25,
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(
                Sizes.size11,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
          ),
        ),
        Positioned(
          left: 20,
          child: Container(
            height: 30,
            width: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(
                Sizes.size10,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
          ),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size12,
          ),
          decoration: BoxDecoration(
            color:
                !inverted || isDarkMode(context) ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(Sizes.size6),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              size: Sizes.size16 + Sizes.size2,
              color: !inverted || isDarkMode(context)
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
