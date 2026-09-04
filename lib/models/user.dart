class User {
  final String id;
  final String name;
  final int age;
  final String role; // ELDERLY, CAREGIVER, ADMIN

  User({
    required this.id,
    required this.name,
    required this.age,
    this.role = 'ELDERLY',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      role: json['role'] ?? 'ELDERLY',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'role': role,
    };
  }
}
