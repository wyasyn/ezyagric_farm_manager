import 'package:flutter/material.dart';
import '../models/season_plan.dart';
import '../models/actual_activity.dart';
import '../models/activity_type.dart';
import '../services/season_service.dart';
import '../utils/date_formatter.dart';

class LogActualActivityScreen extends StatefulWidget {
  final SeasonPlan seasonPlan;

  const LogActualActivityScreen({Key? key, required this.seasonPlan})
      : super(key: key);

  @override
  State<LogActualActivityScreen> createState() =>
      _LogActualActivityScreenState();
}

class _LogActualActivityScreenState extends State<LogActualActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  final SeasonService _seasonService = SeasonService();

  ActivityType? _selectedActivityType;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _logActivity() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity type')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final activity = ActualActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      seasonPlanId: widget.seasonPlan.id,
      activityType: _selectedActivityType!,
      actualDate: _selectedDate,
      actualCostUgx: double.parse(_costController.text.trim()),
      notes: _notesController.text.trim(),
    );

    await _seasonService.addActualActivity(activity);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity logged successfully')),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Actual Activity'),
        backgroundColor: Colors.blue,
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
              'Record Field Activity',
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
                  labelText: 'Actual Date',
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
                labelText: 'Actual Cost (UGX)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter actual cost';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Any observations or comments',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _logActivity,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Log Activity', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
