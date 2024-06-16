import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/utils.dart';

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authenticationRepository);
  }

  Future<void> signInWithGitHub(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.signInWithGitHub(),
    );

    if (state.hasError) {
      showFirebaseErrorSnackBar(context, state.error);
    } else {
      context.go("/home");
    }
  }
}
