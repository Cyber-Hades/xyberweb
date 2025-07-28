import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:xyberweb/view/screens/home_screen.dart';
import 'package:xyberweb/view/screens/splash_screen.dart';
import 'package:xyberweb/view/screens/vendor_home_screen.dart';
import 'package:xyberweb/view/screens/verify_email_screen.dart';

import 'package:xyberweb/view_model/auth_view_model.dart';
import 'core/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const SplashScreen();

    await user.reload();
    if (!user.emailVerified) {
      return const VerifyEmailScreen();
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userType = doc['type'];

      if (userType == 0) {
        return const StudentHomeScreen();
      } else if (userType == 1) {
        return const VendorHomeScreen();
      } else {
        return const SplashScreen();
      }
    } catch (e) {
      return const SplashScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            title: 'XyberWeb',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeNotifier.themeMode,
            home: FutureBuilder<Widget>(
              future: _getInitialScreen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return snapshot.data!;
                }
              },
            ),
          );
        },
      ),
    );
  }
}
