class InternshipModel {
  final String id;
  final String title;
  final String description;
  final String company;
  final String duration;

  InternshipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.duration,
  });

  factory InternshipModel.fromMap(Map<String, dynamic> map, String id) {
    return InternshipModel(
      id: id,
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? 'No Description',
      company: map['company'] ?? 'No Company',
      duration: map['duration'] ?? 'N/A',
    );
  }
}
