import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/nav_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static final screens = [
    const Center(child: Text("Home")),
    const Center(child: Text("Search")),
    const Center(child: Text("Home")),
    const Center(child: Text("Search")),
    const Center(child: Text("Home")),
  ];

  int _selectedIndex = 0;

  void _onTap(int index) => setState(() {
        _selectedIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavTab(
                isSelected: _selectedIndex == 0,
                title: 'Home',
                icon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
              ),
              NavTab(
                isSelected: _selectedIndex == 1,
                title: 'Discover',
                icon: FontAwesomeIcons.magnifyingGlass,
                onTap: () => _onTap(1),
              ),
              NavTab(
                isSelected: _selectedIndex == 3,
                title: 'Inbox',
                icon: FontAwesomeIcons.message,
                onTap: () => _onTap(3),
              ),
              NavTab(
                isSelected: _selectedIndex == 4,
                title: 'Profile',
                icon: FontAwesomeIcons.user,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
