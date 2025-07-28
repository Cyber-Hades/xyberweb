import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:xyberweb/view/screens/edit_profile_screen.dart';
import 'package:xyberweb/view/screens/language_screen.dart';
import 'package:xyberweb/view/screens/theme_selection_screen.dart';
import 'package:xyberweb/view/screens/privacy_policy_screen.dart';
import 'package:xyberweb/view/screens/vendor_demo_projects_screen.dart';
import 'package:xyberweb/view/screens/vendor_home_screen.dart';
import 'package:xyberweb/view/screens/vendor_project_screen.dart';

import '../../widgets/vendor_bottom_navbar.dart'; //

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  String name = '';
  String email = '';
  String photoUrl = '';
  bool _showBottomNav = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        name = doc['name'] ?? '';
        email = doc['email'] ?? '';
        photoUrl = user.photoURL ?? '';
      });
    }
  }

  void _onNavTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorHomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorProjectScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorDemoProjectsScreen()));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Vendor Profile'),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            if (scrollNotification.direction == ScrollDirection.reverse && _showBottomNav) {
              setState(() => _showBottomNav = false);
            } else if (scrollNotification.direction == ScrollDirection.forward && !_showBottomNav) {
              setState(() => _showBottomNav = true);
            }
          }
          return true;
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.02, width * 0.05, 100),
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const AssetImage("assets/images/user.jpg") as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              trailing: Switch(value: true, onChanged: (val) {}),
            ),
            const Divider(),
            const SizedBox(height: 24),
            const Text("App Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("Theme"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemeSelectionScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()));
              },
            ),
            const Divider(),
            const SizedBox(height: 24),
            const Text("More", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "All rights reserved by XyberWeb\nApp version 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _showBottomNav
          ? VendorBottomNavBar(
        currentIndex: 3,
        onTap: _onNavTapped,
      )
          : null,
    );
  }
}
