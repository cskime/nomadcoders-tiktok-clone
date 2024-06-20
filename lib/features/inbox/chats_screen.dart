import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_users_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat.dart';
import 'package:tiktok_clone/features/inbox/view_models/chats_view_model.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const routeName = 'chats';
  static const routeURL = '/chats';
  const ChatsScreen({super.key});

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends ConsumerState<ChatsScreen> {
  void _onAddPressed() async {
    final newChat = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatUsersScreen(),
      ),
    );

    if (newChat is Chat) {
      await ref.read(chatsViewModelProvider.notifier).createChat(newChat);
    }
  }

  void _onChatTap(int index) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {'chatId': '$index'},
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
      body: ref.watch(chatsViewModelProvider).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final chat = data[index];
              final otherUserName = ref
                  .read(chatsViewModelProvider.notifier)
                  .otherUserNameFromChat(chat);
              return ListTile(
                onTap: () => _onChatTap(index),
                leading: CircleAvatar(
                  radius: 32,
                  foregroundImage: const NetworkImage(
                    'https://avatars.githubusercontent.com/u/42177438?v=4',
                  ),
                  child: Text(otherUserName.substring(0, 2).toUpperCase()),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      otherUserName,
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
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
