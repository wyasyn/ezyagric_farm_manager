import 'dart:ui';
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
    final headerHeight = MediaQuery.of(context).size.height * 0.26;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Glassy header
          SizedBox(
            height: headerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image — fallback to color if asset missing
                Image.asset(
                  'assets/images/farm_background.jpg',
                  fit: BoxFit.cover,
                ),

                // gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: .5),
                        Colors.black.withValues(alpha: .2),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // blur for glass feel
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.transparent),
                ),

                // header content
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).padding.top + 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _compactBackButton(),
                          const Spacer(),
                          _roundedChip('${_seasons.length}'),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.farm.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.farm.sizeAcres} acres',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Season Plans (${_seasons.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _seasons.isEmpty
                    ? _emptySeasons()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        itemCount: _seasons.length,
                        itemBuilder: (context, index) {
                          final season = _seasons[index];
                          return _seasonListItem(season);
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
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _compactBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.chevron_left, color: Colors.white),
      ),
    );
  }

  Widget _roundedChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _emptySeasons() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 90, color: Colors.grey.shade300),
            const SizedBox(height: 18),
            Text(
              'No season plans yet',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create a season plan for this farm.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seasonListItem(SeasonPlan season) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeasonSummaryScreen(seasonPlan: season),
          ),
        );
        _loadSeasons();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.grass, color: Colors.green, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    season.cropName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    season.seasonName,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
