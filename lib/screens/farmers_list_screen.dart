import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/farmer.dart';
import '../services/farmer_service.dart';
import '../widgets/farmer_card.dart';
import 'add_farmer_screen.dart';
import 'farmer_detail_screen.dart';

class FarmersListScreen extends StatefulWidget {
  const FarmersListScreen({Key? key}) : super(key: key);

  @override
  State<FarmersListScreen> createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends State<FarmersListScreen> {
  final FarmerService _farmerService = FarmerService();
  List<Farmer> _farmers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmers();
  }

  Future<void> _loadFarmers() async {
    setState(() => _isLoading = true);
    final farmers = await _farmerService.getAllFarmers();
    setState(() {
      _farmers = farmers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.25;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // ================= HEADER =================
          SizedBox(
            height: headerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                const Image(
                  image: AssetImage('assets/images/farm_background.jpg'),
                  fit: BoxFit.cover,
                ),

                // Soft dark overlay (minimal)
                Container(
                  color: Colors.black.withOpacity(0.35),
                ),

                // Subtle blur (lighter than before)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.transparent),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).padding.top + 12,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          MinimalBackButton(
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          _countChip(_farmers.length),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        'Farmers',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _farmers.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                        itemCount: _farmers.length,
                        itemBuilder: (context, index) {
                          final farmer = _farmers[index];
                          return FarmerCard(
                            farmer: farmer,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FarmerDetailScreen(farmer: farmer),
                                ),
                              );
                              _loadFarmers();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: Colors.green[600],
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFarmerScreen()),
          );
          _loadFarmers();
        },
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _countChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.35),
            ),
            const SizedBox(height: 20),
            const Text(
              'No farmers yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first farmer.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// MINIMAL BACK BUTTON COMPONENT
// =======================================================

class MinimalBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const MinimalBackButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<MinimalBackButton> createState() => _MinimalBackButtonState();
}

class _MinimalBackButtonState extends State<MinimalBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 120));

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.9).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
