import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _animatedListKey = GlobalKey<AnimatedListState>();

  final List<int> _items = [];

  void _addItem() {
    _animatedListKey.currentState?.insertItem(
      _items.length,
      duration: const Duration(milliseconds: 500),
    );
    _items.add(_items.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct messages'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(FontAwesomeIcons.plus),
          )
        ],
      ),
      body: AnimatedList(
        key: _animatedListKey,
        padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: ListTile(
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
                    Text(
                      'AntonioBM ($index)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
            ),
          );
        },
      ),
    );
  }
}
