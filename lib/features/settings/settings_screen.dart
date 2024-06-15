import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _signOut(BuildContext context, WidgetRef ref) {
    ref.read(authenticationRepository).signOut();
    context.go("/");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.small),
          child: ListView(
            children: [
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigViewModel).muted,
                onChanged: ref.read(playbackConfigViewModel.notifier).setMuted,
                title: const Text('Muted video'),
                subtitle: const Text('Video will be muted by default.'),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigViewModel).autoplay,
                onChanged:
                    ref.read(playbackConfigViewModel.notifier).setAutoplay,
                title: const Text('Autoplay'),
                subtitle: const Text('Video will start playing automatically.'),
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (_) {},
                title: const Text('Enable notifications'),
                subtitle: const Text('They will be cute.'),
              ),
              CheckboxListTile(
                value: false,
                onChanged: (_) {},
                checkColor: Colors.white,
                activeColor: Colors.black,
                title: const Text('Marketing emails'),
                subtitle: const Text("We don't spam you."),
              ),
              ListTile(
                onTap: () => showAboutDialog(
                  context: context,
                  applicationVersion: '1.0',
                  applicationLegalese: 'All rights reserved',
                ),
                title: const Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('About this app...'),
              ),
              const AboutListTile(),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2030),
                  );
                  if (kDebugMode) {
                    print(date);
                  }

                  if (!context.mounted) return;

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) {
                    print(time);
                  }

                  if (!context.mounted) return;

                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          useMaterial3: false,
                          appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (kDebugMode) {
                    print(range);
                  }
                },
                title: const Text('What is your birthday?'),
              ),
              ListTile(
                title: const Text('Log out (iOS)'),
                textColor: Colors.red,
                onTap: () => showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Plase dont go'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Yes'),
                        onPressed: () => _signOut(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Log out (Android)'),
                textColor: Colors.red,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Plase dont go'),
                    actions: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.car),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () => _signOut(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Log out (iOS / Bottom)'),
                textColor: Colors.red,
                onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Are you sure?'),
                    message: const Text('Please dont go'),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        child: const Text('Yes'),
                        onPressed: () => _signOut(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
