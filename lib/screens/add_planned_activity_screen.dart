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

      // Reset form
      setState(() {
        _selectedActivityType = null;
        _costController.clear();
        _selectedDate = DateTime.now().add(const Duration(days: 7));
        _isSaving = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _finishPlanning() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SeasonSummaryScreen(seasonPlan: widget.seasonPlan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Planned Activities'),
        backgroundColor: Colors.green,
        actions: [
          TextButton(
            onPressed: _finishPlanning,
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.grass, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.seasonPlan.cropName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.seasonPlan.seasonName,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Add Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ActivityType>(
              decoration: const InputDecoration(
                labelText: 'Activity Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
              initialValue: _selectedActivityType,
              items: ActivityType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(getActivityDisplayName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedActivityType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select an activity type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Target Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormatter.formatDate(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Estimated Cost (UGX)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter estimated cost';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveActivity,
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
                  : const Text('Add Activity', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _finishPlanning,
              icon: const Icon(Icons.check_circle),
              label: const Text('Finish Planning & View Summary'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
