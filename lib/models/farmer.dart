class Farmer {
  final String id;
  final String name;
  final String phoneNumber;

  Farmer({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
