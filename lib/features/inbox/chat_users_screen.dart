import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_users_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatUsersScreen extends ConsumerStatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatUsersScreenState();
}

class _ChatUsersScreenState extends ConsumerState<ChatUsersScreen> {
  UserProfileModel? _selectedUser;
  bool get _selected => _selectedUser != null;

  void _onStartChatPressed() {
    if (_selectedUser == null) {
      return;
    }

    final newChat = ref
        .read(chatUsersViewModelProvider.notifier)
        .createNewChatToUser(_selectedUser!);

    Navigator.of(context).pop(newChat);
  }

  void _onUserSelected(UserProfileModel user) {
    setState(() {
      _selectedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _selected ? _onStartChatPressed : null,
            child: Text(
              "Start chat",
              style: TextStyle(
                color: _selected ? Colors.black : Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: ref.watch(chatUsersViewModelProvider).when(
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    foregroundImage: const NetworkImage(
                      'https://avatars.githubusercontent.com/u/42177438?v=4',
                    ),
                    child: Text(user.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Checkbox(
                    value: _selectedUser?.name == user.name,
                    onChanged: (_) => _onUserSelected(user),
                  ),
                  onTap: () => _onUserSelected(user),
                );
              },
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
    );
  }
}
