class UserModel {
  final String id;
  final String name;
  final String email;
  final int type;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      type: data['type'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type,
    };
  }
}
