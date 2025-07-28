import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? studentId;
  bool showAllProjects = true;

  @override
  void initState() {
    super.initState();
    studentId = _auth.currentUser?.uid;
    print("Student UID: $studentId");
  }

  Future<void> acceptProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).update({
        'status': 'ongoing',
        'studentId': studentId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project accepted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget buildProjectCard(DocumentSnapshot doc, {bool showAccept = false}) {
    final data = doc.data() as Map<String, dynamic>;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data['description'] ?? 'No Description',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  label: Text("₹${data['budget'] ?? 'N/A'}"),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: const TextStyle(color: Colors.green),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(data['timeline'] ?? 'No Timeline'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            if (showAccept) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => acceptProject(doc.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Accept'),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }


  Widget buildProjectList(bool allProjects) {
    final query = allProjects
        ? _firestore
        .collection('projects')
        .where('status', isEqualTo: 'created')
        .orderBy('createdAt', descending: true)
        : _firestore
        .collection('projects')
        .where('status', isEqualTo: 'ongoing')
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true);

    print("Querying for: ${allProjects ? "created" : "ongoing"} projects");

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());

        if (snapshot.hasError) {
          print("Firestore error: ${snapshot.error}");
          return const Center(child: Text('Something went wrong'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print("No data found for this query.");
          return Center(
              child: Text(allProjects ? 'No projects available' : 'No ongoing projects'));
        }

        final docs = snapshot.data!.docs;
        print("Fetched ${docs.length} project(s)");

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) => buildProjectCard(
            docs[index],
            showAccept: allProjects,
          ),
        );
      },
    );
  }

  Widget buildCustomTabSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => showAllProjects = true),
                child: Container(
                  decoration: BoxDecoration(
                    color: showAllProjects ? Colors.blueAccent : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "All Projects",
                    style: TextStyle(
                      color: showAllProjects ? Colors.white : Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.blueAccent),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => showAllProjects = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: !showAllProjects ? Colors.blueAccent : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Ongoing",
                    style: TextStyle(
                      color: !showAllProjects ? Colors.white : Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          buildCustomTabSelector(),
          Expanded(child: buildProjectList(showAllProjects)),
        ],
      ),
    );
  }
}
