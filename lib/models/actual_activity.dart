import 'activity_type.dart';

class ActualActivity {
  final String id;
  final String seasonPlanId;
  final ActivityType activityType;
  final DateTime actualDate;
  final double actualCostUgx;
  final String notes;
  final String? plannedActivityId;

  ActualActivity({
    required this.id,
    required this.seasonPlanId,
    required this.activityType,
    required this.actualDate,
    required this.actualCostUgx,
    required this.notes,
    this.plannedActivityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonPlanId': seasonPlanId,
      'activityType': activityTypeToString(activityType),
      'actualDate': actualDate.toIso8601String(),
      'actualCostUgx': actualCostUgx,
      'notes': notes,
      'plannedActivityId': plannedActivityId,
    };
  }

  factory ActualActivity.fromJson(Map<String, dynamic> json) {
    return ActualActivity(
      id: json['id'],
      seasonPlanId: json['seasonPlanId'],
      activityType: activityTypeFromString(json['activityType']),
      actualDate: DateTime.parse(json['actualDate']),
      actualCostUgx: (json['actualCostUgx'] as num).toDouble(),
      notes: json['notes'],
      plannedActivityId: json['plannedActivityId'],
    );
  }
}
