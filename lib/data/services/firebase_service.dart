// 📁 lib/data/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Email Validator
  bool isValidEmail(String email) {
    // Reject emails like s@g.com or short domains
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w{2,}$");
    return regex.hasMatch(email) && !email.contains("s@g.com");
  }

  /// 🔐 Register user + Send Email Verification
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required int type,
  }) async {
    try {
      if (!isValidEmail(email)) return "Enter a valid email address";

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await userCredential.user!.sendEmailVerification(); // 🔔 Send verification

      final userData = {
        'uid': uid,
        'name': name,
        'email': email,
        'type': type,
        'createdAt': Timestamp.now(),
      };

      await _firestore.collection('users').doc(uid).set(userData);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// 🔐 Login with email verification check
  Future<int?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        await _auth.signOut(); // Block access if not verified
        return -1; // Custom code to represent "not verified"
      }

      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) return userDoc['type'];
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 🔐 Forgot Password via Email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// 🔐 Google Sign-In
  Future<int?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final uid = user.uid;

      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'type': 0,
          'createdAt': Timestamp.now(),
        });
        return 0;
      } else {
        return doc['type'];
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      return null;
    }
  }

  /// 🔓 Get current user
  User? getCurrentUser() => _auth.currentUser;

  /// 🔓 Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
