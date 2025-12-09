import 'activity_type.dart';

class PlannedActivity {
  final String id;
  final String seasonPlanId;
  final ActivityType activityType;
  final DateTime targetDate;
  final double estimatedCostUgx;

  PlannedActivity({
    required this.id,
    required this.seasonPlanId,
    required this.activityType,
    required this.targetDate,
    required this.estimatedCostUgx,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonPlanId': seasonPlanId,
      'activityType': activityTypeToString(activityType),
      'targetDate': targetDate.toIso8601String(),
      'estimatedCostUgx': estimatedCostUgx,
    };
  }

  factory PlannedActivity.fromJson(Map<String, dynamic> json) {
    return PlannedActivity(
      id: json['id'],
      seasonPlanId: json['seasonPlanId'],
      activityType: activityTypeFromString(json['activityType']),
      targetDate: DateTime.parse(json['targetDate']),
      estimatedCostUgx: (json['estimatedCostUgx'] as num).toDouble(),
    );
  }
}
