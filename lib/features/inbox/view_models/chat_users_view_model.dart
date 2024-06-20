import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repositories/user_repository.dart';

final chatUsersViewModelProvider =
    AsyncNotifierProvider<ChatUsersViewModel, List<UserProfileModel>>(
  () => ChatUsersViewModel(),
);

class ChatUsersViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final UserProfileModel _myUser;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _authenticationRepository = ref.read(authenticationRepository);
    _userRepository = ref.read(userRepository);
    final usersJson = await _userRepository.fetchProfiles();
    final users =
        usersJson.map((user) => UserProfileModel.fromJson(user)).toList();
    _myUser = users
        .firstWhere((user) => user.uid == _authenticationRepository.user!.uid);
    return users.where((user) => user.uid != _myUser.uid).toList();
  }

  Chat createNewChatToUser(UserProfileModel user) {
    return Chat(
      user1Id: _myUser.uid,
      user1Name: _myUser.name,
      user2Id: user.uid,
      user2Name: user.name,
    );
  }
}
