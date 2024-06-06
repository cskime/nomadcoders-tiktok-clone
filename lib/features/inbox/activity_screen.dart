import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  final _notifications = List.generate(20, (index) => '${index}h');

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _arrowAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  late final Animation<Offset> _panelAnimation = Tween(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(_animationController);

  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "All activity",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "Likes",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "Comments",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "Mentions",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "Followers",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "From TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  bool _showsBarrier = false;

  @override
  void initState() {
    super.initState();
  }

  void _onDismissed(String notification) {
    setState(() {
      _notifications.remove(notification);
    });
  }

  void _toggleAnimations() async {
    if (_animationController.isCompleted) {
      // reverse가 실행되는 중에는 상태를 바꾸지 않음
      // 따라서, modal과 barrier에 적용된 animation이 끝까지 실행됨
      // Barrier animation이 끝나서 투명색이 된 이후 상태 변경 코드 실행
      // rebuild 되면서 barrier를 widget tree에서 제외
      // 즉, hide animation이 완전히 끝난 뒤에 실제로 화면에서 삭제한다.
      await _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _showsBarrier = !_showsBarrier;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _toggleAnimations,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('All Activity'),
              Gaps.h6,
              RotationTransition(
                turns: _arrowAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Gaps.v14,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'New',
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Gaps.v10,
              for (final notification in _notifications)
                Dismissible(
                  key: ValueKey(notification),
                  onDismissed: (direction) => _onDismissed(notification),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: Sizes.size10),
                      child: FaIcon(
                        FontAwesomeIcons.checkDouble,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(left: Sizes.size10),
                      child: FaIcon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.white,
                        size: Sizes.size32,
                      ),
                    ),
                  ),
                  child: ListTile(
                    minVerticalPadding: Sizes.size16,
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode(context)
                            ? Colors.grey.shade800
                            : Colors.white,
                        border: Border.all(
                          color: isDarkMode(context)
                              ? Colors.grey.shade900
                              : Colors.grey.shade400,
                          width: Sizes.size2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(FontAwesomeIcons.bell),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: 'Account updates:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size16,
                          color: isDarkMode(context) ? null : Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: ' Upload longer videos',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: ' $notification',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size14,
                    ),
                  ),
                )
            ],
          ),
          if (_showsBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              dismissible: true,
              onDismiss: _toggleAnimations,
            ),
          SlideTransition(
            position: _panelAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Sizes.size4),
                  bottomRight: Radius.circular(Sizes.size4),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab['icon'],
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
