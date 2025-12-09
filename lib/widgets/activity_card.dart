import 'package:flutter/material.dart';
import '../models/activity_type.dart';
import '../utils/date_formatter.dart';
import '../utils/currency_formatter.dart';
import 'status_badge.dart';
import '../services/season_service.dart';

class ActivityCard extends StatelessWidget {
  final PlannedActivityWithStatus activityWithStatus;

  const ActivityCard({Key? key, required this.activityWithStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activity = activityWithStatus.activity;
    final status = activityWithStatus.status;
    final matchingActual = activityWithStatus.matchingActual;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    getActivityDisplayName(activity.activityType),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Target: ${DateFormatter.formatDate(activity.targetDate)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Estimated: ${CurrencyFormatter.formatUgx(activity.estimatedCostUgx)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (matchingActual != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Actual: ${DateFormatter.formatDate(matchingActual.actualDate)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Cost: ${CurrencyFormatter.formatUgx(matchingActual.actualCostUgx)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              if (matchingActual.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notes: ${matchingActual.notes}',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
