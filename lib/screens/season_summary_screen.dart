import 'package:flutter/material.dart';
import '../models/season_plan.dart';
import '../services/season_service.dart';
import '../widgets/activity_card.dart';
import '../widgets/cost_summary_card.dart';
import 'log_actual_activity_screen.dart';
import 'add_planned_activity_screen.dart';

class SeasonSummaryScreen extends StatefulWidget {
  final SeasonPlan seasonPlan;

  const SeasonSummaryScreen({Key? key, required this.seasonPlan})
      : super(key: key);

  @override
  State<SeasonSummaryScreen> createState() => _SeasonSummaryScreenState();
}

class _SeasonSummaryScreenState extends State<SeasonSummaryScreen> {
  final SeasonService _seasonService = SeasonService();
  SeasonSummary? _summary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() => _isLoading = true);
    final summary = await _seasonService.getSeasonSummary(widget.seasonPlan.id);
    setState(() {
      _summary = summary;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Season Summary'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _summary == null
              ? const Center(child: Text('No data available'))
              : RefreshIndicator(
                  onRefresh: _loadSummary,
                  child: ListView(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        color: Colors.green.shade50,
                        child: Column(
                          children: [
                            const Icon(Icons.grass,
                                size: 50, color: Colors.green),
                            const SizedBox(height: 8),
                            Text(
                              widget.seasonPlan.cropName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.seasonPlan.seasonName,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      CostSummaryCard(
                        estimatedCost: _summary!.totalEstimatedCost,
                        actualCost: _summary!.totalActualCost,
                        variance: _summary!.costVariance,
                        overdueCount: _summary!.overdueCount,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.list_alt, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  'Activities (${_summary!.plannedActivities.length})',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddPlannedActivityScreen(
                                      seasonPlan: widget.seasonPlan,
                                    ),
                                  ),
                                );
                                _loadSummary();
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add More'),
                            ),
                          ],
                        ),
                      ),
                      if (_summary!.plannedActivities.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.event_note,
                                    size: 80, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  'No activities planned yet',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._summary!.plannedActivities
                            .map((activityWithStatus) {
                          return ActivityCard(
                              activityWithStatus: activityWithStatus);
                        }).toList(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LogActualActivityScreen(seasonPlan: widget.seasonPlan),
            ),
          );
          _loadSummary();
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add_task),
        label: const Text('Log Actual Activity'),
      ),
    );
  }
}
