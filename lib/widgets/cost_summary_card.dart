import 'package:flutter/material.dart';
import '../utils/currency_formatter.dart';

class CostSummaryCard extends StatelessWidget {
  final double estimatedCost;
  final double actualCost;
  final double variance;
  final int overdueCount;

  const CostSummaryCard({
    Key? key,
    required this.estimatedCost,
    required this.actualCost,
    required this.variance,
    required this.overdueCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final varianceColor = variance > 0 ? Colors.red : Colors.green;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cost Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated'),
              Text(
                CurrencyFormatter.formatUgx(estimatedCost),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Actual'),
              Text(
                CurrencyFormatter.formatUgx(actualCost),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Variance'),
              Text(
                CurrencyFormatter.formatVariance(variance),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: varianceColor),
              ),
            ],
          ),
          if (overdueCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    '$overdueCount overdue ${overdueCount == 1 ? 'activity' : 'activities'}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
