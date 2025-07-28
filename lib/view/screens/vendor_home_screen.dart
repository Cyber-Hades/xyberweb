import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xyberweb/view/screens/profile_screen.dart';
import 'package:xyberweb/view/screens/vendor_profile_screen.dart';
import 'package:xyberweb/view/screens/vendor_project_screen.dart';

import 'auth_screen.dart';
import 'contact_us_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'vendor_demo_projects_screen.dart';
import 'vendor_terms.dart';
import 'contact_vendor.dart';
import '../../core/constants.dart';
import '../../widgets/vendor_bottom_navbar.dart';
import '../../widgets/workshop_card.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;
  bool _showBottomNav = true;
  int _currentIndex = 0;

  String vendorName = "Vendor";
  String vendorEmail = "vendor@email.com";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadVendorData();
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

  Future<void> _loadVendorData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          vendorName = doc['name'] ?? 'Vendor';
          vendorEmail = doc['email'] ?? user.email ?? 'vendor@email.com';
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

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorHomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorDemoProjectsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorProjectScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorProfileScreen()));
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      appBar: _isScrollingDown
          ? null
          : AppBar(
        title: Text("Hello, $vendorName 👋"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: width * 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Lottie.asset(
                          'assets/lottie/vendor_animation.json',
                          height: width * 0.5,
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.defaultPadding(context)),
                  child: Text("Project Overview", style: AppTextStyles.subheading(context)),
                ),
                WorkshopCard(
                  title: "Website for XYZ Ltd",
                  description: "Build an interactive company profile site with admin panel and backend integration.",
                ),
                WorkshopCard(
                  title: "App for Patna Mall",
                  description: "A modern mobile shopping app with barcode scanner and inventory sync.",
                ),
              ],
            ),
          ),
          if (_showBottomNav)
            Align(
              alignment: Alignment.bottomCenter,
              child: VendorBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onBottomNavTap,
              ),
            ),
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
                  child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(vendorName),
            accountEmail: Text(vendorEmail),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
            ),
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            title: const Text("Dashboard"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorHomeScreen())),
          ),
          ListTile(
            title: const Text("Current Projects"),
            leading: const Icon(Icons.work_history),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorProjectScreen())),
          ),
          ListTile(
            title: const Text("New Demos"),
            leading: const Icon(Icons.new_releases),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorDemoProjectsScreen())),
          ),
          ListTile(
            title: const Text("Contact Us"),
            leading: const Icon(Icons.support_agent),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VendorContactUsScreen())),
          ),
          ListTile(
            title: const Text("Terms & Conditions"),
            leading: const Icon(Icons.policy),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TermsAndConditionsVendorScreen())),
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen())),
          ),
          const Spacer(),
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
    );
  }
}
