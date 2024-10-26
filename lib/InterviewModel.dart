class User {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;

  User({required this.id, required this.name, required this.email, required this.gender, required this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }
}
