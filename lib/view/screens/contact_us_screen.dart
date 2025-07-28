import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Future<void> _launchWhatsApp() async {
      final Uri url = Uri.parse("https://wa.me/917903859277");

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open WhatsApp.")),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentHomeScreen()), // Replace with your home screen
          ),
        ),
        title: const Text('Contact Us'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We’re here to help! If you have any questions, feedback, or suggestions, feel free to reach out to us using the information below.',
              style: TextStyle(
                fontSize: width * 0.04,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Divider Section
            const Divider(thickness: 1.2),

            const SizedBox(height: 20),
            _buildContactTile(
              context,
              icon: Icons.email,
              iconColor: Colors.blue,
              title: 'Email',
              subtitle: 'contact@xyberweb.in',
            ),
            const SizedBox(height: 15),
            _buildContactTile(
              context,
              icon: Icons.phone,
              iconColor: Colors.green,
              title: 'Phone',
              subtitle: '+91 7903859277\nMon - Sat, 10 AM to 6 PM',
            ),
            const SizedBox(height: 15),
            _buildContactTile(
              context,
              icon: Icons.location_on,
              iconColor: Colors.redAccent,
              title: 'Office Address',
              subtitle: 'Patna, Bihar\nXyberWeb HQ',
            ),
            const SizedBox(height: 30),

        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              _launchWhatsApp();
            },

            icon: const Icon(Icons.message, size: 24, color: Colors.white),
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Text(
                'Chat with us on WhatsApp',
                style: TextStyle(
                  fontSize: width * 0.042,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.greenAccent,
              backgroundColor: const Color(0xFF25D366),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: width * 0.035,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        )
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(BuildContext context,
      {required IconData icon,
        required Color iconColor,
        required String title,
        required String subtitle}) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: width * 0.08),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.045,
                  )),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
