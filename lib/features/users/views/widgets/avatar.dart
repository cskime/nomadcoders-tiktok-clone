import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class Avatar extends ConsumerWidget {
  const Avatar({
    super.key,
    required this.name,
  });

  final String name;

  Future<void> _onTap() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    if (xfile == null) {
      return;
    }

    final file = File(xfile.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _onTap,
      child: CircleAvatar(
        radius: Sizes.size52,
        foregroundColor: Colors.blue,
        foregroundImage: const NetworkImage(
          'https://avatars.githubusercontent.com/u/42177438?v=4',
        ),
        child: Text(name),
      ),
    );
  }
}
