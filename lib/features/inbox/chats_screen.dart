import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct messages'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.plus),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 32,
              foregroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/42177438?v=4',
              ),
              child: Text('JY'),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'AntonioBM',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '2:16PM',
                  style: TextStyle(
                    fontSize: Sizes.size12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            subtitle: const Text("Don't forget to make video"),
          ),
        ],
      ),
    );
  }
}
