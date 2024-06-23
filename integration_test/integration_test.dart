import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAuth.instance.signOut();
  });

  testWidgets("Create account flow", (tester) async {
    // Start from the sign up screen.
    await tester.pumpWidget(
      const ProviderScope(child: TikTokApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text("Sign up for TikTok"), findsOneWidget);

    // Find sign up with email button and tap it to move to the email screen.
    final emailButton = find.text('Use email & password');
    expect(emailButton, findsOneWidget);
    await tester.tap(emailButton);
    await tester.pumpAndSettle();
    expect(find.text("Create username"), findsOneWidget);

    // Find the username input text field and type a username.
    final usernameTextField = find.byType(TextField).first;
    expect(usernameTextField, findsOneWidget);
    const username = "username";
    await tester.enterText(usernameTextField, username);
    await tester.pumpAndSettle();

    // Go to the email screen.
    final goToEmailButton = find.text("Next");
    expect(goToEmailButton, findsOneWidget);
    await tester.tap(goToEmailButton);
    await tester.pumpAndSettle();
    expect(find.text('What is your email, $username?'), findsOneWidget);

    // Find the email input text field and type an email.
    final emailTextField = find.byType(TextField).first;
    expect(emailTextField, findsOneWidget);
    await tester.enterText(emailTextField, "test@testing.com");
    await tester.pumpAndSettle();

    // Go to the password screen.
    final goToPasswordButton = find.text("Next");
    expect(goToPasswordButton, findsOneWidget);
    await tester.tap(goToPasswordButton);
    await tester.pumpAndSettle();
    expect(find.text("Password"), findsOneWidget);

    // Find the email input text field and type an email.
    final passwordTextField = find.byType(TextField).first;
    expect(passwordTextField, findsOneWidget);
    await tester.enterText(passwordTextField, "asdf1234");
    await tester.pumpAndSettle();

    // Go to the birthday screen.
    final goToBirthdayButton = find.text("Next");
    expect(goToBirthdayButton, findsOneWidget);
    await tester.tap(goToBirthdayButton);
    await tester.pumpAndSettle();

    // Create an account and go to the interest screen.
    final createAccountButton = find.text("Next");
    expect(createAccountButton, findsOneWidget);
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();
  });

  tearDown(() {});
}
