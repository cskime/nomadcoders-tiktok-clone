import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final notificationsProvider =
    AsyncNotifierProvider.family<NotificationsProvider, void, BuildContext>(
  () => NotificationsProvider(),
);

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final _database = FirebaseFirestore.instance;
  final _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authenticationRepository).user;
    await _database.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    FirebaseMessaging.onMessage.listen(
      (message) => print(message.data),
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print(message.data);
        context.pushNamed(ChatsScreen.routeName);
      },
    );

    final message = await _messaging.getInitialMessage();
    print(message?.data["screen"]);

    if (context.mounted && message != null) {
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext arg) async {
    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }

    await updateToken(token);
    await initListeners(arg);

    _messaging.onTokenRefresh.listen(
      (newToken) async => await updateToken(newToken),
    );
  }
}
