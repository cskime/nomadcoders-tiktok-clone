import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeURL = '/';
  static const routeName = 'sign_up';
  const SignUpScreen({super.key});

  void _onLogInTap(BuildContext context) {
    context.pushNamed(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UsernameScreen(),
    ));
  }

  void _onGitHubLoginTap(BuildContext context, WidgetRef ref) async {
    await ref.read(socialAuthProvider.notifier).signInWithGitHub(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
            child: Column(
              children: [
                Gaps.v80,
                const Text(
                  // S.of(context).signUpTitle('TikTok'),
                  "Sign up for TikTok",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    S.of(context).signUpSubtitle(2),
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v40,
                if (orientation == Orientation.portrait) ...[
                  AuthButton(
                    icon: const FaIcon(FontAwesomeIcons.user),
                    text: S.of(context).emailPasswordButton,
                    onPressed: () => _onEmailTap(context),
                  ),
                  Gaps.v16,
                  AuthButton(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    text: 'Continue with GitHub',
                    onPressed: () => _onGitHubLoginTap(context, ref),
                  ),
                ],
                if (orientation == Orientation.landscape)
                  Row(
                    children: [
                      Expanded(
                          child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        // text: S.of(context).emailPasswordButton,
                        text: 'Use email & password',
                        onPressed: () => _onEmailTap(context),
                      )),
                      Gaps.h16,
                      Expanded(
                        child: AuthButton(
                          icon: const FaIcon(FontAwesomeIcons.apple),
                          text: S.of(context).appleButton,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: isDarkMode(context) ? null : Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size32,
              bottom: Sizes.size64,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).alreadyHaveAccount),
                Gaps.h5,
                GestureDetector(
                  onTap: () => _onLogInTap(context),
                  child: Text(
                    // S.of(context).login,
                    "Log in",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
