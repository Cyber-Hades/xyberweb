import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = '';
  String email = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        name = doc['name'] ?? '';
        email = doc['email'] ?? '';
        photoUrl = user.photoURL ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: ListView(
          padding:
          EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
          children: [
            // 🔵 Profile Header
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : const AssetImage("assets/images/user.jpg") as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
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
                // TODO: Navigate to Edit Profile Screen
              },
            ),
            const Divider(),
        
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to Change Password Screen
              },
            ),
            const Divider(),
        
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              trailing: Switch(
                value: true,
                onChanged: (val) {
                  // TODO: Handle toggle
                },
              ),
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
                // TODO: Navigate to Theme Selection
              },
            ),
            const Divider(),
        
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to Language Settings
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
                // TODO: Open Privacy Policy
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
