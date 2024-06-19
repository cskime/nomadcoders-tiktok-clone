import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_users_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = 'chats';
  static const routeURL = '/chats';
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _duration = const Duration(milliseconds: 300);
  int _insertIndex = 0;

  void _onAddPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ChatUsersScreen(),
    ));

    // _animatedListKey.currentState?.insertItem(
    //   _insertIndex,
    //   duration: _duration,
    // );
  }

  void _deleteItem(int index) {
    _animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: Container(
          color: Colors.red,
          child: _makeTile(index),
        ),
      ),
      duration: _duration,
    );
    _insertIndex -= 1;
  }

  void _onChatTap(int index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {'chatId': '$index'},
    );
  }

  Widget _makeTile(int index) {
    return ListTile(
      onLongPress: () => _deleteItem(index),
      onTap: () => _onChatTap(index),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct messages'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _onAddPressed,
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
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
