import 'package:flutter/material.dart';
import 'package:xyberweb/view/screens/vendor_home_screen.dart'; // Replace with your correct path

class TermsAndConditionsVendorScreen extends StatelessWidget {
  const TermsAndConditionsVendorScreen({super.key});

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
            MaterialPageRoute(builder: (context) => const VendorHomeScreen()),
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
                'Welcome Vendor!',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'By registering as a vendor on XyberWeb, you agree to the following terms and conditions. Please read them carefully before continuing:',
                style: TextStyle(fontSize: width * 0.038, color: Colors.grey[700], height: 1.4),
              ),
              const SizedBox(height: 24),

              _buildSection('1. Professional Conduct', 'Vendors must maintain a high standard of professionalism and integrity when working with students and clients.', context),
              _buildSection('2. Project Transparency', 'All project details and deliverables must be communicated clearly and honestly.', context),
              _buildSection('3. Data Handling', 'Vendor information is securely stored and will be used only for project collaborations and communication.', context),
              _buildSection('4. Platform Use', 'Any misuse of the platform may result in removal or suspension of your account.', context),
              _buildSection('5. Changes to Terms', 'These terms may be updated periodically. Please review them regularly.', context),

              const SizedBox(height: 30),
              Text(
                'Thank you for partnering with XyberWeb!',
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
