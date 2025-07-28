import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xyberweb/view/screens/vendor_home_screen.dart';

class VendorDemoProjectsScreen extends StatelessWidget {
  const VendorDemoProjectsScreen({super.key});

  // Sample demo project data
  final List<Map<String, String>> demoProjects = const [
    {
      'title': 'E-commerce App',
      'description': 'A Flutter-based e-commerce app built for local stores with cart, payment, and delivery features.',
      'videoUrl': 'https://www.youtube.com/watch?v=1gDhl4leEzA',
    },
    {
      'title': 'Smart Home Automation',
      'description': 'Control home appliances via mobile using IoT, NodeMCU and Flutter app.',
      'videoUrl': 'https://www.youtube.com/watch?v=eNUYgA6V47g',
    },
    {
      'title': 'Online Learning Portal',
      'description': 'An app for accessing recorded lectures, quizzes, and notes for BCA students.',
      'videoUrl': 'https://www.youtube.com/watch?v=AF7xI4v6pYA',
    },
  ];

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
              MaterialPageRoute(builder: (context) => const VendorHomeScreen()), // Replace with your home screen
            ),
          ),
        title: const Text('Demo Projects'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
        child: demoProjects.isEmpty
            ? const Center(
          child: Text(
            "No demo projects uploaded yet.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: demoProjects.length,
          itemBuilder: (context, index) {
            final project = demoProjects[index];
            return _buildProjectCard(
              context,
              title: project['title']!,
              description: project['description']!,
              videoUrl: project['videoUrl']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context,
      {required String title,
        required String description,
        required String videoUrl}) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              )),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                fontSize: width * 0.038,
                color: Colors.grey[800],
                height: 1.4,
              )),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: () => _launchVideo(videoUrl),
              icon: const Icon(Icons.play_circle_outline,
                  color: Colors.blueAccent),
              label: const Text(
                'Watch Demo',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
