import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/password_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/sign_up_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class EmailScreenArgs {
  EmailScreenArgs({required this.username});
  final String username;
}

class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  EmailScreenState createState() => EmailScreenState();
}

class EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _email = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _isEmailValid() {
    if (_email.isEmpty) return null;

    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!regExp.hasMatch(_email)) {
      return 'Email not valid';
    }

    return null;
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (_email.isEmpty || _isEmailValid() != null) return;

    final userData = ref.read(signUpUserData.notifier).state;
    ref.read(signUpUserData.notifier).state = {
      ...userData,
      "email": _email,
    };

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PasswordScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v20,
              Text(
                'What is your email, ${widget.username}?',
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: _isEmailValid(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              Gaps.v16,
              FormButton(
                title: 'Next',
                disabled: _email.isEmpty || _isEmailValid() != null,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
