import 'package:flutter/material.dart';

import 'home_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
          ),
        ),
        title: const Text('Terms & Conditions'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.06),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to XyberWeb!',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'By using our app, you agree to the following terms and conditions. Please read them carefully before continuing:',
                style: TextStyle(fontSize: width * 0.038, color: Colors.grey[700], height: 1.4),
              ),
              const SizedBox(height: 24),

              _buildSection('1. Educational Content', 'All workshops, videos, and materials are provided for learning purposes only.', context),
              _buildSection('2. User Data', 'Your data is securely stored and used only to enhance your learning experience.', context),
              _buildSection('3. Prohibited Use', 'Do not misuse the platform or distribute unauthorized content.', context),
              _buildSection('4. Modification', 'Terms may change. Please review periodically for updates.', context),

              const SizedBox(height: 30),
              Text(
                'Thank you for being a part of XyberWeb!',
                style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.042)),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: width * 0.037,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
