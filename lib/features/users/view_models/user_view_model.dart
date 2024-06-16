import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

final usersProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    // sign up 해야 하는 경우
    return UserProfileModel.empty();

    // login 하는 경우
    // fetch the profile of the user from the authentication
  }

  Future<void> createAccount(UserCredential userCredential) async {
    if (userCredential.user == null) {
      throw Exception("Account not created");
    }

    state = AsyncValue.data(UserProfileModel(
      bio: "undefined",
      link: "undefined",
      uid: userCredential.user!.uid,
      name: userCredential.user!.displayName ?? "anonymous",
      email: userCredential.user!.email ?? "undefined",
    ));
  }
}
