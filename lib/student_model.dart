class Student {
  final String name;
  final String email;
  final String registerDate;

  Student({
    required this.name,
    required this.email,
    required this.registerDate,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['user_full_name'] ?? '',
      email: json['user_email'] ?? '',
      registerDate: json['user_register_datetime'] ?? '',
    );
  }
}
