import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/services/firebase_service.dart';
import '../data/models/user_model.dart'; // ✅ Ensure you import your user model

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool isLoading = false;
  int? userType; // 0 = student, 1 = vendor

  UserModel? _userModel;
  UserModel? get userModel => _userModel; // ✅ Getter for UI access

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// 🔐 Register user
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required int type,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    try {
      setLoading(true);
      final error = await _firebaseService.registerUser(
        name: name,
        email: email,
        password: password,
        type: type,
      );

      if (error == null) {
        onSuccess();
        return null;
      } else {
        return error;
      }
    } catch (e) {
      return "Something went wrong";
    } finally {
      setLoading(false);
    }
  }

  /// 🔐 Login user
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required Function(int type) onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      setLoading(true);
      final type = await _firebaseService.loginUser(
        email: email,
        password: password,
      );
      if (type != null) {
        userType = type;
        onSuccess(type);
      } else {
        onError();
      }
    } finally {
      setLoading(false);
    }
  }

  /// 🔐 Google Sign-In
  Future<void> signInWithGoogle({
    required BuildContext context,
    required Function(int type) onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      setLoading(true);
      final type = await _firebaseService.signInWithGoogle();

      if (type != null) {
        userType = type;
        print("✅ Google Sign-In successful. User type: $type");
        onSuccess(type);
      } else {
        print("❌ Google Sign-In returned null (maybe cancelled or failed silently)");
        onError();
      }
    } catch (e, stackTrace) {
      print("❌ Google Sign-In Exception: $e");
      print("📍 Stack trace: $stackTrace");
      onError();
    } finally {
      setLoading(false);
    }
  }

  /// 📄 Fetch user data
  Future<void> fetchUserData(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snapshot.exists) {
      _userModel = UserModel.fromMap(snapshot.data()!);
      notifyListeners();
    }
  }

  /// 🔓 Logout user
  Future<void> logout() async {
    try {
      print("🔓 Logging out user...");
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      userType = null;
      _userModel = null;
      notifyListeners();
      print("✅ Logout complete");
    } catch (e) {
      print("❌ Logout failed: $e");
    }
  }
}
