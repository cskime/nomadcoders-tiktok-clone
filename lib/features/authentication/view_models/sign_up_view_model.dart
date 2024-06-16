import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_model.dart';
import 'package:tiktok_clone/utils.dart';

final signUpUserData = StateProvider((ref) => {});

final signUpViewModel = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authenticationRepository);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final userData = ref.read(signUpUserData);
    final users = ref.read(usersProvider.notifier);
    state = await AsyncValue.guard(
      () async {
        final userCredential =
            await _authenticationRepository.signUpWithEmailAndPassword(
          userData["email"],
          userData["password"],
        );

        if (userCredential.user == null) {
          throw Exception("Account not created");
        }

        users.createProfile(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          name: userData["name"] ?? userCredential.user!.displayName,
        );
      },
    );

    if (state.hasError) {
      showFirebaseErrorSnackBar(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}
