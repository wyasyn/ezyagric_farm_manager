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
    const headerHeight = 160.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _summary == null
                  ? const Center(child: Text('No data available'))
                  : RefreshIndicator(
                      onRefresh: _loadSummary,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 100, top: 16),
                        children: [
                          // header card
                          Container(
                            height: headerHeight,
                            margin: const EdgeInsets.fromLTRB(16, 40, 16, 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade600,
                                  Colors.green.shade500,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.grass,
                                      color: Colors.white, size: 36),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.seasonPlan.cropName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.seasonPlan.seasonName,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${_summary!.plannedActivities.length} activities',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    if (_summary!.overdueCount > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade700,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${_summary!.overdueCount} overdue',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'On track',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // cost summary
                          CostSummaryCard(
                            estimatedCost: _summary!.totalEstimatedCost,
                            actualCost: _summary!.totalActualCost,
                            variance: _summary!.costVariance,
                            overdueCount: _summary!.overdueCount,
                          ),

                          // activities header + add button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.list_alt, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Activities',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
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
                                  label: const Text('Add'),
                                ),
                              ],
                            ),
                          ),

                          // activities list or empty
                          if (_summary!.plannedActivities.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  Icon(Icons.event_note,
                                      size: 84, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No activities planned yet',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          else
                            ..._summary!.plannedActivities.map((a) {
                              return ActivityCard(activityWithStatus: a);
                            }).toList(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

          // custom back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.chevron_left, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'logActualBtn',
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
        backgroundColor: Colors.green.shade600,
        icon: const Icon(Icons.add_task),
        label: const Text('Log Actual'),
      ),
    );
  }
}
