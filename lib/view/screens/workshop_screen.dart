import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xyberweb/data/models/workshop_model.dart';
import 'package:xyberweb/view_model/workshop_view_model.dart';
import 'home_screen.dart';

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({super.key});

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen> {
  final WorkshopViewModel viewModel = WorkshopViewModel();
  List<WorkshopModel> allWorkshops = [];
  List<WorkshopModel> enrolledWorkshops = [];
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final all = await viewModel.fetchAll();
      final enrolled = await viewModel.fetchEnrolled(user.uid);
      setState(() {
        allWorkshops = all;
        enrolledWorkshops = enrolled;
      });
    }
  }

  bool _isEnrolled(String id) {
    return enrolledWorkshops.any((w) => w.id == id);
  }

  Future<void> _enroll(String workshopId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final workshop = allWorkshops.firstWhere((w) => w.id == workshopId);
      await viewModel.enroll(user.uid, workshopId);
      setState(() {
        enrolledWorkshops.add(workshop);
      });
    }
  }

  Future<void> _removeEnrolled(String workshopId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await viewModel.removeEnrollment(user.uid, workshopId);
      setState(() {
        enrolledWorkshops.removeWhere((w) => w.id == workshopId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['All Workshops', 'Enrolled'];
    final showList =
    _selectedTab == 0 ? allWorkshops : enrolledWorkshops;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Workshops"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(tabs.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedTab == i
                          ? Colors.blueAccent
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        color: _selectedTab == i
                            ? Colors.white
                            : Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildWorkshopList(showList,
                isEnrolledTab: _selectedTab == 1),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopList(List<WorkshopModel> workshops,
      {required bool isEnrolledTab}) {
    if (workshops.isEmpty) {
      return const Center(
        child: Text(
          "No workshops found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: workshops.length,
      itemBuilder: (context, index) {
        final workshop = workshops[index];
        final enrolled = _isEnrolled(workshop.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workshop.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                workshop.description,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(
                    "Duration: ${workshop.duration}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: isEnrolledTab
                    ? TextButton.icon(
                  onPressed: () => _removeEnrolled(workshop.id),
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text(
                    "Unenroll",
                    style: TextStyle(color: Colors.red),
                  ),
                )
                    : enrolled
                    ? const Text(
                  "Enrolled",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                )
                    : ElevatedButton.icon(
                  onPressed: () => _enroll(workshop.id),
                  icon: const Icon(Icons.check),
                  label: const Text("Enroll"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
