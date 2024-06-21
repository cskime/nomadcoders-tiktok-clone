import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);

class NotificationsProvider extends AsyncNotifier {
  final _database = FirebaseFirestore.instance;
  final _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authenticationRepository).user;
    await _database.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    FirebaseMessaging.onMessage.listen(
      (remoteMessage) => print("Got message in the foreground"),
    );
  }

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }

    await updateToken(token);
    await initListeners();

    _messaging.onTokenRefresh.listen(
      (newToken) async => await updateToken(newToken),
    );
  }
}
