class SeasonPlan {
  final String id;
  final String farmId;
  final String cropName;
  final String seasonName;

  SeasonPlan({
    required this.id,
    required this.farmId,
    required this.cropName,
    required this.seasonName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'cropName': cropName,
      'seasonName': seasonName,
    };
  }

  factory SeasonPlan.fromJson(Map<String, dynamic> json) {
    return SeasonPlan(
      id: json['id'],
      farmId: json['farmId'],
      cropName: json['cropName'],
      seasonName: json['seasonName'],
    );
  }
}
