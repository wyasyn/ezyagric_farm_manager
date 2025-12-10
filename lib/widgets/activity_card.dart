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

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  getActivityDisplayName(activity.activityType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Target: ${DateFormatter.formatDate(activity.targetDate)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.attach_money, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Estimated: ${CurrencyFormatter.formatUgx(activity.estimatedCostUgx)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          if (matchingActual != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.green),
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
                const Icon(Icons.attach_money, size: 14, color: Colors.green),
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
                style:
                    const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
