import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // Current logged-in user
  static User? get currentUser => _auth.currentUser;

  // Check whether a user is logged in
  static bool get isLoggedIn =>
      _auth.currentUser != null;

  // Sign up
  static Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Login
  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Send password reset email
  static Future<void> resetPassword(
    String email,
  ) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }
}