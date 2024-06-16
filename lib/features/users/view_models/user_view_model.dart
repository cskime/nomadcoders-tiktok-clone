import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repositories/user_repository.dart';

final usersProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepository);
    // sign up 해야 하는 경우
    return UserProfileModel.empty();

    // login 하는 경우
    // fetch the profile of the user from the authentication
  }

  Future<void> createProfile({
    required String uid,
    String? name,
    String? email,
    String? birth,
  }) async {
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      bio: birth ?? "undefined",
      link: "undefined",
      uid: uid,
      name: name ?? "anonymous",
      email: email ?? "undefined",
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
  }
}
