import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repositories/user_repository.dart';

final chatUsersViewModelProvider =
    AsyncNotifierProvider<ChatUsersViewModel, List<UserProfileModel>>(
  () => ChatUsersViewModel(),
);

class ChatUsersViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _authenticationRepository = ref.read(authenticationRepository);
    _userRepository = ref.read(userRepository);
    final users = await _userRepository.fetchProfiles();
    return users
        .map((user) => UserProfileModel.fromJson(user))
        .where((user) => user.uid != _authenticationRepository.user!.uid)
        .toList();
  }
}
