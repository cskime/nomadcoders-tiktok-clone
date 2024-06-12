import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/utils.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
    required this.selectedIndex,
  });

  final String title;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final void Function() onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final color = selectedIndex == 0
        ? Colors.white
        : isDarkMode(context)
            ? Colors.white
            : Colors.black;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: AnimatedOpacity(
          opacity: isSelected ? 1 : 0.6,
          duration: const Duration(milliseconds: 250),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                isSelected ? selectedIcon : icon,
                color: color,
              ),
              Gaps.v5,
              Text(
                title,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
