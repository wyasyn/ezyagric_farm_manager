import 'package:flutter/material.dart';
import '../models/season_plan.dart';
import '../models/planned_activity.dart';
import '../models/activity_type.dart';
import '../services/season_service.dart';
import '../utils/date_formatter.dart';
import 'season_summary_screen.dart';

class AddPlannedActivityScreen extends StatefulWidget {
  final SeasonPlan seasonPlan;

  const AddPlannedActivityScreen({Key? key, required this.seasonPlan})
      : super(key: key);

  @override
  State<AddPlannedActivityScreen> createState() =>
      _AddPlannedActivityScreenState();
}

class _AddPlannedActivityScreenState extends State<AddPlannedActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final SeasonService _seasonService = SeasonService();

  ActivityType? _selectedActivityType;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  bool _isSaving = false;

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity type')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final activity = PlannedActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      seasonPlanId: widget.seasonPlan.id,
      activityType: _selectedActivityType!,
      targetDate: _selectedDate,
      estimatedCostUgx: double.parse(_costController.text.trim()),
    );

    await _seasonService.addPlannedActivity(activity);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity added successfully')),
      );

      setState(() {
        _selectedActivityType = null;
        _costController.clear();
        _selectedDate = DateTime.now().add(const Duration(days: 7));
        _isSaving = false;
      });
    }
  }

  void _finishPlanning() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SeasonSummaryScreen(seasonPlan: widget.seasonPlan),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// SCROLLABLE CONTENT
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 160),
            children: [
              // TOP BAR
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
                    'Add Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 32),

              // Season header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.grass, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.seasonPlan.cropName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.seasonPlan.seasonName,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Activity Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Plan your farming activities for this season.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              _buildLabel('Activity Type*'),
              const SizedBox(height: 8),
              DropdownButtonFormField<ActivityType>(
                decoration: _inputDecoration(),
                initialValue: _selectedActivityType,
                items: ActivityType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(getActivityDisplayName(type)),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedActivityType = value),
                validator: (value) =>
                    value == null ? 'Please select an activity type' : null,
              ),

              const SizedBox(height: 20),

              _buildLabel('Target Date*'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: _inputDecoration(),
                  child: Text(
                    DateFormatter.formatDate(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Estimated Cost (UGX)*'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                decoration:
                    _inputDecoration().copyWith(hintText: 'e.g., 150000'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter estimated cost';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),

      /// TRUE BOTTOM ACTION BAR (2 BUTTONS)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Add Activity',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _finishPlanning,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[700],
                    side: BorderSide(color: Colors.green.shade700, width: 1.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Finish Planning & View Summary',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
