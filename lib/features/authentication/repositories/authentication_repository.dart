import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get loggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;
}

final authenticationRepository = Provider((ref) => AuthenticationRepository());
