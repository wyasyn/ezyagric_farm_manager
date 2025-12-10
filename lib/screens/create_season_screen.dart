import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../models/season_plan.dart';
import '../services/season_service.dart';
import 'add_planned_activity_screen.dart';

class CreateSeasonScreen extends StatefulWidget {
  final Farm farm;

  const CreateSeasonScreen({Key? key, required this.farm}) : super(key: key);

  @override
  State<CreateSeasonScreen> createState() => _CreateSeasonScreenState();
}

class _CreateSeasonScreenState extends State<CreateSeasonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _seasonNameController = TextEditingController();
  final SeasonService _seasonService = SeasonService();
  bool _isSaving = false;

  @override
  void dispose() {
    _cropNameController.dispose();
    _seasonNameController.dispose();
    super.dispose();
  }

  Future<void> _createSeason() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final season = SeasonPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmId: widget.farm.id,
      cropName: _cropNameController.text.trim(),
      seasonName: _seasonNameController.text.trim(),
    );

    await _seasonService.addSeason(season);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddPlannedActivityScreen(seasonPlan: season),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Season plan created! Now add activities')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // TOP BAR (same as AddFarmerScreen)
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Create Season Plan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Section Title
              const Text(
                'Season Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Provide the season name and crop details.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 24),

              _inputLabel("Crop name*"),
              const SizedBox(height: 8),
              _styledInput(
                controller: _cropNameController,
                hint: "e.g., Maize",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter crop name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _inputLabel("Season name*"),
              const SizedBox(height: 8),
              _styledInput(
                controller: _seasonNameController,
                hint: "e.g., 2025A, Season 1",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter season name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Button (same style)
              ElevatedButton(
                onPressed: _isSaving ? null : _createSeason,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable label
  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Reusable styled input
  Widget _styledInput({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: controller.text.isNotEmpty
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
      ),
      validator: validator,
      onChanged: (_) => setState(() {}),
    );
  }
}
