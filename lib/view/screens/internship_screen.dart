import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../view_model/internship_view_model.dart';
import '../../data/models/internship_model.dart';
import 'package:xyberweb/view/screens/home_screen.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  final InternshipViewModel _viewModel = InternshipViewModel();
  late Future<List<InternshipModel>> _allInternships;
  late Future<List<InternshipModel>> _enrolledInternships;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _allInternships = _viewModel.fetchInternships();
    _enrolledInternships = _fetchEnrolledInternships();
  }

  Future<void> _enrollInInternship(InternshipModel internship) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('enrollments')
        .doc(internship.id);

    await doc.set({
      'title': internship.title,
      'company': internship.company,
      'duration': internship.duration,
      'description': internship.description,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enrolled successfully')),
    );

    setState(() {
      _enrolledInternships = _fetchEnrolledInternships();
    });
  }

  Future<void> _removeFromEnrolled(String internshipId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('enrollments')
          .doc(internshipId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from enrolled')),
      );

      setState(() {
        _enrolledInternships = _fetchEnrolledInternships();
      });
    } catch (e) {
      print("Error removing internship: $e");
    }
  }

  Future<List<InternshipModel>> _fetchEnrolledInternships() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('enrollments')
        .get();

    return snapshot.docs
        .map((doc) => InternshipModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Enrolled'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Internships", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(tabs.length, (i) {
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedTab == i ? Colors.blueAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      color: _selectedTab == i ? Colors.white : Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<InternshipModel>>(
              future: _selectedTab == 0 ? _allInternships : _enrolledInternships,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No internships available"));
                }

                final internships = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: internships.length,
                  itemBuilder: (context, index) {
                    final internship = internships[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(internship.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("Company: ${internship.company}"),
                          Text("Duration: ${internship.duration}"),
                          const SizedBox(height: 6),
                          Text(internship.description),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedTab == 0) {
                                  _enrollInInternship(internship);
                                } else {
                                  _removeFromEnrolled(internship.id);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedTab == 0
                                    ? Colors.blueAccent
                                    : Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(_selectedTab == 0 ? 'Enroll Now' : 'Remove'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
