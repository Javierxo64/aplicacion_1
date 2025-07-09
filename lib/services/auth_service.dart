import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    hostedDomain: 'utem.cl',
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      _user = userCredential.user;
      _token = googleAuth.idToken;

      notifyListeners();
    } catch (e) {
      debugPrint('Error en login: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _user = null;
    _token = null;
    notifyListeners();
  }
}