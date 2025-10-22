class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('User.fromJson - Raw JSON: $json'); // Debug
    final name = json['name'] ?? json['username'] ?? 'Unknown';
    print('User.fromJson - Resolved name: $name'); // Debug
    
    return User(
      id: json['id']?.toString() ?? '', // Asegurar que id sea string
      email: json['email']?.toString() ?? '',
      name: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
