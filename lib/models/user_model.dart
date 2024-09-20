class User {
  final int? id;
  final String name;
  final String company;

  User({this.id, required this.name,required this.company});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      company: map['company'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company,
    };
  }
}
