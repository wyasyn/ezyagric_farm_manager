import 'package:flutter/material.dart';
import '../models/activity_status.dart';

class StatusBadge extends StatelessWidget {
  final ActivityStatus status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case ActivityStatus.COMPLETED:
        color = Colors.green;
        text = 'Completed';
        break;
      case ActivityStatus.UPCOMING:
        color = Colors.orange;
        text = 'Upcoming';
        break;
      case ActivityStatus.OVERDUE:
        color = Colors.red;
        text = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
