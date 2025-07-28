import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xyberweb/view/screens/vendor_home_screen.dart';

class VendorProjectScreen extends StatefulWidget {
  const VendorProjectScreen({super.key});

  @override
  State<VendorProjectScreen> createState() => _VendorProjectScreenState();
}

class _VendorProjectScreenState extends State<VendorProjectScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TabController _tabController;

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _createProject() async {
    if (_formKey.currentState!.validate()) {
      try {
        final uid = _auth.currentUser?.uid;
        await _firestore.collection('projects').add({
          'title': _titleController.text,
          'description': _descController.text,
          'timeline': _timelineController.text,
          'budget': _budgetController.text,
          'status': 'created',
          'vendorId': uid,
          'studentId': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully')),
        );

        _titleController.clear();
        _descController.clear();
        _timelineController.clear();
        _budgetController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildCreateProjectTab() {
    final uid = _auth.currentUser?.uid;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Create New Project", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Project Title'),
                  validator: (value) => value!.isEmpty ? 'Enter title' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Project Description'),
                  validator: (value) => value!.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _timelineController,
                  decoration: const InputDecoration(labelText: 'Timeline (e.g. 2 weeks)'),
                  validator: (value) => value!.isEmpty ? 'Enter timeline' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(labelText: 'Budget (in ₹)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter budget' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Project'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const Text(
            "Created Projects (Not Yet Accepted)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Created Projects
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('projects')
                .where('vendorId', isEqualTo: uid)
                .where('status', isEqualTo: 'created')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                return const Text('No created projects found.');

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final createdAt = data['createdAt']?.toDate();
                  final timeAgo = createdAt != null ? _formatTimeAgo(createdAt) : 'Time unknown';

                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 2,
                    child: ListTile(
                      title: Text(data['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timeline: ${data['timeline']}'),
                          Text('Budget: ₹${data['budget']}'),
                          Text('Created: $timeAgo'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _firestore.collection('projects').doc(doc.id).delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Project deleted')),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingProjectsTab() {
    final uid = _auth.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('projects')
          .where('vendorId', isEqualTo: uid)
          .where('status', isEqualTo: 'ongoing')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
          return const Center(child: Text('No ongoing projects'));

        final docs = snapshot.data!.docs;

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['title'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data['description']),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Timeline: ${data['timeline']}"),
                        Text("₹${data['budget']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _timelineController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Vendor Projects"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VendorHomeScreen()),
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Create Project'),
            Tab(text: 'Ongoing Projects'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateProjectTab(),
          _buildOngoingProjectsTab(),
        ],
      ),
    );
  }
}
