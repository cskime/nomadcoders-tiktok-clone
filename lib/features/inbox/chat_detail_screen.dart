import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const routeName = 'chatDetail';
  static const routeURL = ':chatId';

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemBuilder: (context, index) {
              final isMine = index % 2 == 0;
              return Row(
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Sizes.size14),
                    decoration: BoxDecoration(
                      color:
                          isMine ? Colors.blue : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Sizes.size12),
                        topRight: const Radius.circular(Sizes.size12),
                        bottomLeft: Radius.circular(isMine ? Sizes.size12 : 0),
                        bottomRight: Radius.circular(isMine ? 0 : Sizes.size12),
                      ),
                    ),
                    child: const Text(
                      'This is message!',
                      style: TextStyle(
                          color: Colors.white, fontSize: Sizes.size16),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: 10,
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
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.solidPaperPlane,
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
