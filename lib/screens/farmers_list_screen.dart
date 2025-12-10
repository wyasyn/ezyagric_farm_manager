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
    final headerHeight = MediaQuery.of(context).size.height * 0.26;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Modern Gradient + Glass Header
          SizedBox(
            height: headerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                const Image(
                  image: AssetImage('assets/images/farm_background.jpg'),
                  fit: BoxFit.cover,
                ),

                // Glassmorphic overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.25),
                        Colors.grey.shade100.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),

                // Frosted blur effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.transparent),
                ),

                // Content
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
                          AnimatedBackButton(
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          _roundedCountChip(_farmers.length),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        'Farmers',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CONTENT AREA
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _farmers.isEmpty
                    ? _buildEmptyState()
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
                                  builder: (context) =>
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
      floatingActionButton: AnimatedAddButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFarmerScreen()),
          );
          _loadFarmers();
        },
      ),
    );
  }

  // Modern counter chip
  Widget _roundedCountChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .85),
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
        '$count',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  // Modern Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 90,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 20),
            const Text(
              'No farmers added yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the button below to register your first farmer.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- EXISTING ANIMATIONS (unchanged) ----------------------

class AnimatedBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedBackButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<AnimatedBackButton> createState() => _AnimatedBackButtonState();
}

class _AnimatedBackButtonState extends State<AnimatedBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 140),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .4),
                ),
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 28,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedAddButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedAddButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<AnimatedAddButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _scaleController.forward();
        _rotateController.forward();
      },
      onTapUp: (_) async {
        await _scaleController.reverse();
        await _rotateController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _scaleController.reverse();
        _rotateController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _rotateController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade400,
                    Colors.green.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: .35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: _rotateAnimation.value * 3.14159 * 2,
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
