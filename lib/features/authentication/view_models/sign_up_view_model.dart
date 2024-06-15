import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';

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

  Future<void> signUp() async {
    state = const AsyncValue.loading();
    final userData = ref.read(signUpUserData);
    state = await AsyncValue.guard(
      () async => await _authenticationRepository.signUp(
        userData["email"],
        userData["password"],
      ),
    );
  }
}
