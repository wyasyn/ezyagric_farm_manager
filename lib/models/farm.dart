class Farm {
  final String id;
  final String farmerId;
  final String name;
  final double sizeAcres;

  Farm({
    required this.id,
    required this.farmerId,
    required this.name,
    required this.sizeAcres,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'name': name,
      'sizeAcres': sizeAcres,
    };
  }

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      farmerId: json['farmerId'],
      name: json['name'],
      sizeAcres: (json['sizeAcres'] as num).toDouble(),
    );
  }
}
