// lib/view/screens/student_home_screen.dart
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xyberweb/view/screens/auth_screen.dart';
import 'package:xyberweb/view/screens/contact_us_screen.dart';
import 'package:xyberweb/view/screens/profile_screen.dart';
import 'package:xyberweb/view/screens/project_screen.dart';
import 'package:xyberweb/view/screens/terms_and_conditions_screen.dart';
import 'package:xyberweb/view/screens/video_screen.dart';
import 'package:xyberweb/view/screens/workshop_screen.dart';
import '../../utils/global_notifiers.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/workshop_card.dart';
import 'internship_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SizedBox(),
    VideosScreen(),
    WorkshopsScreen(),
    ProfileScreen(),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;
  bool _showBottomNav = true;

  String studentName = "Loading...";
  String studentEmail = "";
  String studentPhotoUrl = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadUserData();

    shouldRefreshHomeData.addListener(() {
      if (shouldRefreshHomeData.value) {
        _loadUserData();
        shouldRefreshHomeData.value = false; // reset
      }
    });
  }
  void dispose() {
    shouldRefreshHomeData.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _showBottomNav = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (_isScrollingDown) {
        setState(() {
          _isScrollingDown = false;
          _showBottomNav = true;
        });
      }
    }
  }

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

  Future<void> _launchForm() async {
    final Uri formUrl = Uri.parse("https://docs.google.com/forms/d/1fMQtbkRUxJoOBxGgEoDJRZhjRchNJmOpr-R8s773PJs/edit");
    if (await canLaunchUrl(formUrl)) {
      await launchUrl(formUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          studentName = doc['name'] ?? 'No Name';
          studentEmail = doc['email'] ?? 'No Email';
          studentPhotoUrl = user.photoURL ?? "";
        });
      }
    }
  }


  Widget buildWorkshopCard({
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(imageUrl, width: double.infinity, height: 180, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _launchForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Register'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final List<Map<String, String>> carouselItems = [
      {
        "title": "Internship Offers",
        "image": "assets/lottie/WorkingOnline.json",
      },
      {
        "title": "New Workshop: Agentic AI",
        "image": "assets/lottie/AIanimation.json",
      },
      {
        "title": "Recorded Lectures Added",
        "image": "assets/lottie/videooffers.json",
      },
    ];

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(height: 180, autoPlay: true, enlargeCenterPage: true),
            items: carouselItems.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Lottie.asset(
                            item['image']!,
                            fit: BoxFit.contain,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Popular Workshops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          buildWorkshopCard(
            title: "Robotics Workshop",
            description: "Learn to build your own RC Cars & RC Drones in this hands-on robotics session!",
            imageUrl: "assets/images/robotics.jpg",
          ),
          buildWorkshopCard(
            title: "AI & GenAI Masterclass",
            description: "Explore the world of Gen AI, Agentic AI, and their practical applications.",
            imageUrl: "assets/images/genai.png",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              accountName: Text(studentName, style: TextStyle(color: Colors.white)),
              accountEmail: Text(studentEmail, style: TextStyle(color: Colors.white70)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: studentPhotoUrl.isNotEmpty
                    ? NetworkImage(studentPhotoUrl)
                    : const AssetImage("assets/images/user.jpg") as ImageProvider,
              ),
            ),

            ListTile(title: const Text("Dashboard"), leading: const Icon(Icons.dashboard), onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            }),
            ListTile(title: const Text("Internships"), leading: const Icon(Icons.work), onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InternshipsScreen()));
            }),
            ListTile(title: const Text("Workshops"), leading: const Icon(Icons.school), onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WorkshopsScreen()));
            }),
            ListTile(title: const Text("Projects"), leading: const Icon(Icons.build), onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProjectsScreen()));
            }),
            ListTile(title: const Text("Contact Us"), leading: const Icon(Icons.support_agent), onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ContactUsScreen()));
            }),
            ListTile(title: const Text("Terms & Conditions"), leading: const Icon(Icons.policy), onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()));
            }),
            ListTile(title: const Text("Logout"), leading: const Icon(Icons.logout), onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
            }),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("All rights reserved by XyberWeb\nApp version 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
      appBar: _isScrollingDown || _selectedIndex != 0
          ? null
          : AppBar(
        title: Text("Hello, $studentName 👋"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          _selectedIndex == 0 ? _buildDashboard() : _screens[_selectedIndex],
          if (_showBottomNav)
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNavBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          if (_selectedIndex == 0)
            Positioned(
              bottom: 90,
              right: 20,
              child: GestureDetector(
                onTap: _launchWhatsApp,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
