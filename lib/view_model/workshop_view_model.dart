import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/workshop_model.dart';

class WorkshopViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WorkshopModel>> fetchAll() async {
    final snapshot = await _firestore.collection('workshops').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return WorkshopModel.fromMap(data, doc.id);
    }).toList();
  }

  Future<void> enroll(String userId, String workshopId) async {
    try {
      // Get the workshop data
      final doc = await _firestore.collection('workshops').doc(workshopId).get();
      if (!doc.exists) throw Exception('Workshop not found');

      final workshopData = doc.data() as Map<String, dynamic>;
      workshopData['id'] = doc.id; // Ensure ID is preserved
      workshopData['enrolledAt'] = Timestamp.now();

      // Save to user's enrolled collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('enrolledWorkshops')
          .doc(workshopId)
          .set(workshopData);

    } catch (e) {
      print('Enrollment error: $e');
      rethrow;
    }
  }

  Future<List<WorkshopModel>> fetchEnrolled(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('enrolledWorkshops')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return WorkshopModel.fromMap(data, doc.id);
    }).toList();
  }

  Future<void> removeEnrollment(String userId, String workshopId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('enrolledWorkshops')
        .doc(workshopId)
        .delete();
  }
}
