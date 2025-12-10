import 'package:flutter/material.dart';
import '../models/activity_status.dart';

class StatusBadge extends StatelessWidget {
  final ActivityStatus status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color borderColor;
    late Color textColor;
    late String text;

    switch (status) {
      case ActivityStatus.COMPLETED:
        bgColor = Colors.green.shade100;
        borderColor = Colors.green.shade600;
        textColor = Colors.green.shade800;
        text = 'Completed';
        break;
      case ActivityStatus.UPCOMING:
        bgColor = Colors.orange.shade100;
        borderColor = Colors.orange.shade600;
        textColor = Colors.orange.shade800;
        text = 'Upcoming';
        break;
      case ActivityStatus.OVERDUE:
        bgColor = Colors.red.shade100;
        borderColor = Colors.red.shade600;
        textColor = Colors.red.shade800;
        text = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
