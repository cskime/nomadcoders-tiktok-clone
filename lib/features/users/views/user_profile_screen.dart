import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: Sizes.size4,
                          crossAxisSpacing: Sizes.size4,
                          childAspectRatio: 9 / 12,
                        ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 12,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder:
                                          'assets/images/placeholder.jpg',
                                      image:
                                          'https://images.pexels.com/photos/1198802/pexels-photo-1198802.jpeg?auto=compress&cs=tinysrgb&w=800',
                                    ),
                                  ),
                                  const Positioned(
                                    left: 4,
                                    bottom: 4,
                                    child: Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.play,
                                          color: Colors.white,
                                          size: Sizes.size16,
                                        ),
                                        Gaps.h8,
                                        Text(
                                          '4.1M',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text('Page2'),
                      ),
                    ],
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      title: Text(data.name),
                      actions: [
                        IconButton(
                          onPressed: _onGearPressed,
                          icon: const FaIcon(
                            FontAwesomeIcons.gear,
                            size: Sizes.size20,
                          ),
                        )
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Avatar(
                            name: data.name,
                            uid: data.uid,
                            hasAvatar: data.hasAvatar,
                          ),
                          Gaps.v20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '@${data.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size18,
                                ),
                              ),
                              Gaps.h5,
                              FaIcon(
                                FontAwesomeIcons.solidCircleCheck,
                                color: Colors.blue.shade300,
                                size: Sizes.size16,
                              )
                            ],
                          ),
                          Gaps.v24,
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _VerticalLabel(
                                title: '97',
                                subtitle: 'Following',
                              ),
                              VerticalDivider(
                                width: Sizes.size32,
                                thickness: Sizes.size1,
                                color: Colors.grey,
                                indent: Sizes.size14,
                                endIndent: Sizes.size14,
                              ),
                              _VerticalLabel(
                                title: '10M',
                                subtitle: 'Followers',
                              ),
                              VerticalDivider(
                                width: Sizes.size32,
                                thickness: Sizes.size1,
                                color: Colors.grey,
                                indent: Sizes.size14,
                                endIndent: Sizes.size14,
                              ),
                              _VerticalLabel(
                                title: '194.3M',
                                subtitle: 'Likes',
                              ),
                            ],
                          ),
                          Gaps.v14,
                          FractionallySizedBox(
                            widthFactor: 0.33,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.circular(Sizes.size4),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Gaps.v14,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32),
                            child: Text(
                              data.bio,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Gaps.v14,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.link,
                                size: Sizes.size12,
                              ),
                              Gaps.h4,
                              Text(
                                data.link,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Gaps.v20,
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: PersistentTabBar(),
                      pinned: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}

class _VerticalLabel extends StatelessWidget {
  const _VerticalLabel({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
