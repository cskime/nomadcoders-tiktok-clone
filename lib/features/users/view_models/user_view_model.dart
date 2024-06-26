import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repositories/user_repository.dart';

final usersProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepository);
    _authenticationRepository = ref.read(authenticationRepository);

    if (_authenticationRepository.loggedIn) {
      final userProfile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (userProfile != null) {
        // login 되어서 user profile 정보가 저장되어 있는 경우
        return UserProfileModel.fromJson(userProfile);
      }
    }

    // Logout 된 상태 또는 sign up 해야 하는 /경우
    return UserProfileModel.empty();
  }

  Future<void> createProfile({
    required String uid,
    String? name,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: "All highlights and where to watch live matches on FIFA+",
      link: "https://nomadcoders.co",
      uid: uid,
      name: name ?? "anonymous",
      email: email ?? "undefined",
    );
    await _userRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) {
      return;
    }

    state = AsyncValue.data(
      state.value!.copyWith(hasAvatar: true),
    );
    await _userRepository.updateUser(
      state.value!.uid,
      {"hasAvatar": true},
    );
  }
}
