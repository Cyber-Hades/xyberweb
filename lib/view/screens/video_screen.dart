import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xyberweb/view/screens/profile_screen.dart';
import 'package:xyberweb/view/screens/workshop_screen.dart';
import '../../data/models/video_model.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';

class VideosScreen extends StatelessWidget {
  VideosScreen({super.key});

  final List<VideoModel> videos = [
    VideoModel(
      title: 'GenAI Introduction',
      thumbnailUrl: 'https://img.youtube.com/vi/nPB-41q97zg/0.jpg',
      videoUrl: 'https://youtube.com/shorts/nPB-41q97zg',
    ),
    VideoModel(
      title: 'Flutter in 60 Seconds',
      thumbnailUrl: 'https://img.youtube.com/vi/nPB-41q97zg/0.jpg',
      videoUrl: 'https://youtube.com/shorts/nPB-41q97zg',
    ),
    VideoModel(
      title: 'Agentic AI Explainer',
      thumbnailUrl: 'https://img.youtube.com/vi/nPB-41q97zg/0.jpg',
      videoUrl: 'https://youtube.com/shorts/nPB-41q97zg',
    ),
    VideoModel(
      title: 'Internship Recap - XyberWeb',
      thumbnailUrl: 'https://img.youtube.com/vi/nPB-41q97zg/0.jpg',
      videoUrl: 'https://youtube.com/shorts/nPB-41q97zg',
    ),
    VideoModel(
      title: 'Instagram Reel: AI Magic ✨',
      thumbnailUrl: 'https://img.youtube.com/vi/nPB-41q97zg/0.jpg',
      videoUrl: 'https://youtube.com/shorts/nPB-41q97zg',
    ),
  ];

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WorkshopsScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Videos",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            color: Colors.blue.shade50,
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _launchURL(video.videoUrl),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      video.thumbnailUrl,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.play_circle_fill,
                      color: Colors.redAccent, size: 32),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) => _onNavTapped(context, index),
      ),
    );
  }
}
