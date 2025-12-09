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
      appBar: AppBar(
        title: const Text('Create Season Plan'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.agriculture, color: Colors.green),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Farm:',
                            style: TextStyle(color: Colors.grey)),
                        Text(
                          widget.farm.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cropNameController,
              decoration: const InputDecoration(
                labelText: 'Crop Name',
                hintText: 'e.g., Maize, Beans, Coffee',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.grass),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter crop name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _seasonNameController,
              decoration: const InputDecoration(
                labelText: 'Season Name',
                hintText: 'e.g., 2025A, Season 1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter season name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _createSeason,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Create Season & Add Activities',
                      style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
