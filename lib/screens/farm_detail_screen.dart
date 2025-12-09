import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../models/season_plan.dart';
import '../services/season_service.dart';
import 'create_season_screen.dart';
import 'season_summary_screen.dart';

class FarmDetailScreen extends StatefulWidget {
  final Farm farm;

  const FarmDetailScreen({Key? key, required this.farm}) : super(key: key);

  @override
  State<FarmDetailScreen> createState() => _FarmDetailScreenState();
}

class _FarmDetailScreenState extends State<FarmDetailScreen> {
  final SeasonService _seasonService = SeasonService();
  List<SeasonPlan> _seasons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeasons();
  }

  Future<void> _loadSeasons() async {
    setState(() => _isLoading = true);
    final seasons = await _seasonService.getSeasonsByFarmId(widget.farm.id);
    setState(() {
      _seasons = seasons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farm.name),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.green.shade50,
            child: Column(
              children: [
                const Icon(Icons.agriculture, size: 60, color: Colors.green),
                const SizedBox(height: 12),
                Text(
                  widget.farm.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.farm.sizeAcres} acres',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Season Plans (${_seasons.length})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _seasons.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_note,
                                size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No season plans yet',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap + to create a season plan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _seasons.length,
                        itemBuilder: (context, index) {
                          final season = _seasons[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.grass,
                                  color: Colors.green, size: 32),
                              title: Text(
                                season.cropName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(season.seasonName),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SeasonSummaryScreen(seasonPlan: season),
                                  ),
                                );
                                _loadSeasons();
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSeasonScreen(farm: widget.farm),
            ),
          );
          _loadSeasons();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
