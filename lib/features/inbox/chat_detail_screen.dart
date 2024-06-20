import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'chatDetail';
  static const routeURL = ':chatId';

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  ChatDetailScreenState createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _textEditingController = TextEditingController();

  void _onSendPressed() {
    final text = _textEditingController.text;
    if (text.isEmpty) {
      return;
    }

    ref.read(messagesProvider(widget.chatId).notifier).sendMessage(text);
    _textEditingController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider(widget.chatId)).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: SizedBox(
            width: Sizes.size40,
            height: Sizes.size40,
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  right: Sizes.size2,
                  bottom: Sizes.size2,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/42177438?v=4',
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: Sizes.size16,
                    height: Sizes.size16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: Sizes.size4,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            'Joey (${widget.chatId})',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text('Active now'),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h24,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider(widget.chatId)).when(
                data: (data) => ListView.separated(
                  reverse: true,
                  padding: const EdgeInsets.only(
                    top: Sizes.size20,
                    left: Sizes.size14,
                    right: Sizes.size14,
                    bottom: Sizes.size96 + Sizes.size32,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final message = data[index];
                    final isMine = message.userId ==
                        ref.watch(authenticationRepository).user!.uid;
                    return Row(
                      mainAxisAlignment: isMine
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Sizes.size14),
                          decoration: BoxDecoration(
                            color: isMine
                                ? Colors.blue
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(Sizes.size12),
                              topRight: const Radius.circular(Sizes.size12),
                              bottomLeft:
                                  Radius.circular(isMine ? Sizes.size12 : 0),
                              bottomRight:
                                  Radius.circular(isMine ? 0 : Sizes.size12),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Gaps.v10,
                ),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          Positioned(
            bottom: 0,
            width: MediaQuery.sizeOf(context).width,
            child: BottomAppBar(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Send a message...',
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.faceSmile,
                                color: Colors.black,
                                size: Sizes.size24,
                              ),
                            ],
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(Sizes.size20),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h12,
                  Container(
                    width: Sizes.size36,
                    height: Sizes.size36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: isLoading ? null : _onSendPressed,
                      icon: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white,
                        size: Sizes.size18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
