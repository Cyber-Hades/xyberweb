import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../data/models/internship_model.dart';

class InternshipViewModel {
  final CollectionReference _internshipsCollection =
  FirebaseFirestore.instance.collection('internships'); // Make sure this is the correct collection name

  Future<List<InternshipModel>> fetchInternships() async {
    try {
      QuerySnapshot snapshot = await _internshipsCollection.get();
      print("Fetched ${snapshot.docs.length} internship(s)");

      for (var doc in snapshot.docs) {
        print("Doc ID: ${doc.id}, Data: ${doc.data()}");
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InternshipModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching internships: $e");
      rethrow;
    }
  }

}
