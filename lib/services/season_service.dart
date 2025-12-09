import '../models/season_plan.dart';
import '../models/planned_activity.dart';
import '../models/actual_activity.dart';
import '../models/activity_status.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import 'storage_service.dart';

class SeasonSummary {
  final List<PlannedActivityWithStatus> plannedActivities;
  final List<ActualActivity> actualActivities;
  final double totalEstimatedCost;
  final double totalActualCost;
  final double costVariance;
  final int overdueCount;

  SeasonSummary({
    required this.plannedActivities,
    required this.actualActivities,
    required this.totalEstimatedCost,
    required this.totalActualCost,
    required this.costVariance,
    required this.overdueCount,
  });
}

class PlannedActivityWithStatus {
  final PlannedActivity activity;
  final ActivityStatus status;
  final ActualActivity? matchingActual;

  PlannedActivityWithStatus({
    required this.activity,
    required this.status,
    this.matchingActual,
  });
}

class SeasonService {
  // Season Plans
  Future<List<SeasonPlan>> getAllSeasons() async {
    final data = await StorageService.getList(AppConstants.seasonsKey);
    return data.map((json) => SeasonPlan.fromJson(json)).toList();
  }

  Future<List<SeasonPlan>> getSeasonsByFarmId(String farmId) async {
    final seasons = await getAllSeasons();
    return seasons.where((s) => s.farmId == farmId).toList();
  }

  Future<SeasonPlan?> getSeasonById(String id) async {
    final seasons = await getAllSeasons();
    try {
      return seasons.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addSeason(SeasonPlan season) async {
    final seasons = await getAllSeasons();
    seasons.add(season);
    await StorageService.saveList(
      AppConstants.seasonsKey,
      seasons.map((s) => s.toJson()).toList(),
    );
  }

  // Planned Activities
  Future<List<PlannedActivity>> getAllPlannedActivities() async {
    final data =
        await StorageService.getList(AppConstants.plannedActivitiesKey);
    return data.map((json) => PlannedActivity.fromJson(json)).toList();
  }

  Future<List<PlannedActivity>> getPlannedActivitiesBySeasonId(
      String seasonId) async {
    final activities = await getAllPlannedActivities();
    return activities.where((a) => a.seasonPlanId == seasonId).toList();
  }

  Future<void> addPlannedActivity(PlannedActivity activity) async {
    final activities = await getAllPlannedActivities();
    activities.add(activity);
    await StorageService.saveList(
      AppConstants.plannedActivitiesKey,
      activities.map((a) => a.toJson()).toList(),
    );
  }

  // Actual Activities
  Future<List<ActualActivity>> getAllActualActivities() async {
    final data = await StorageService.getList(AppConstants.actualActivitiesKey);
    return data.map((json) => ActualActivity.fromJson(json)).toList();
  }

  Future<List<ActualActivity>> getActualActivitiesBySeasonId(
      String seasonId) async {
    final activities = await getAllActualActivities();
    return activities.where((a) => a.seasonPlanId == seasonId).toList();
  }

  Future<void> addActualActivity(ActualActivity activity) async {
    final activities = await getAllActualActivities();
    activities.add(activity);
    await StorageService.saveList(
      AppConstants.actualActivitiesKey,
      activities.map((a) => a.toJson()).toList(),
    );
  }

  // ========================================================================
  // PLAN VS ACTUAL LOGIC - This is the core business logic
  // ========================================================================
  Future<SeasonSummary> getSeasonSummary(String seasonId) async {
    final plannedActivities = await getPlannedActivitiesBySeasonId(seasonId);
    final actualActivities = await getActualActivitiesBySeasonId(seasonId);

    // Calculate total estimated cost
    final totalEstimatedCost = plannedActivities.fold<double>(
      0.0,
      (sum, activity) => sum + activity.estimatedCostUgx,
    );

    // Calculate total actual cost
    final totalActualCost = actualActivities.fold<double>(
      0.0,
      (sum, activity) => sum + activity.actualCostUgx,
    );

    // Calculate cost variance
    final costVariance = totalActualCost - totalEstimatedCost;

    // Determine status for each planned activity
    int overdueCount = 0;
    final plannedWithStatus = plannedActivities.map((planned) {
      // Find matching actual activity by activity type
      final matchingActual =
          actualActivities.cast<ActualActivity?>().firstWhere(
                (actual) => actual?.activityType == planned.activityType,
                orElse: () => null,
              );

      ActivityStatus status;
      if (matchingActual != null) {
        // Has matching actual - COMPLETED
        status = ActivityStatus.COMPLETED;
      } else if (DateFormatter.isOverdue(planned.targetDate)) {
        // No actual and past target date - OVERDUE
        status = ActivityStatus.OVERDUE;
        overdueCount++;
      } else {
        // No actual and target date in future - UPCOMING
        status = ActivityStatus.UPCOMING;
      }

      return PlannedActivityWithStatus(
        activity: planned,
        status: status,
        matchingActual: matchingActual,
      );
    }).toList();

    return SeasonSummary(
      plannedActivities: plannedWithStatus,
      actualActivities: actualActivities,
      totalEstimatedCost: totalEstimatedCost,
      totalActualCost: totalActualCost,
      costVariance: costVariance,
      overdueCount: overdueCount,
    );
  }
}
