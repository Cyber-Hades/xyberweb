class WorkshopModel {
  final String id;
  final String title;
  final String description;
  final String duration;

  WorkshopModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
  });

  factory WorkshopModel.fromMap(Map<String, dynamic> data, String id) {
    return WorkshopModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? '1 month',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
    };
  }
}
