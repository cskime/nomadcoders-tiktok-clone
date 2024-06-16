import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnackBar(
  BuildContext context,
  Object? error,
) {
  String? errorMessage;
  if (error is FirebaseException) {
    errorMessage = error.message;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        errorMessage ?? "Something wen't wrong",
      ),
    ),
  );
}
