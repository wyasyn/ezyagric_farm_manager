enum ActivityType { LAND_PREPARATION, PLANTING, WEEDING, SPRAYING, HARVEST }

String activityTypeToString(ActivityType type) {
  return type.toString().split('.').last;
}

ActivityType activityTypeFromString(String str) {
  return ActivityType.values.firstWhere(
    (e) => e.toString().split('.').last == str,
  );
}

String getActivityDisplayName(ActivityType type) {
  switch (type) {
    case ActivityType.LAND_PREPARATION:
      return 'Land Preparation';
    case ActivityType.PLANTING:
      return 'Planting';
    case ActivityType.WEEDING:
      return 'Weeding';
    case ActivityType.SPRAYING:
      return 'Spraying';
    case ActivityType.HARVEST:
      return 'Harvest';
  }
}
